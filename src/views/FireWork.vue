<template>
  <div>
    <div ref="containerRef" class="container"></div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";
import vertexShader from '../shader/lantern/vertex.glsl'
import fragmentShader from '../shader/lantern/fragment.glsl'
import { Water } from "three/examples/jsm/objects/Water2";
import { RGBELoader } from "three/examples/jsm/loaders/RGBELoader";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import FireWork from '@/views/utils/FireWork'
const containerRef = ref<any>(null);
    const axesHelper = new THREE.AxesHelper(5);
    const scene = new THREE.Scene();
    const camera = new THREE.PerspectiveCamera(
    90,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  );
  let fireworks: any[] = [];
onMounted(() => {
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    logarithmicDepthBuffer: true,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  // renderer.outputColorSpace = THREE.sRGBEncoding;
  renderer.toneMappingExposure = 0.2;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
 
  camera.position.set(0, 0, 20);
  scene.add(axesHelper)
  const shaderMaterial = new THREE.ShaderMaterial({
    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    side: THREE.DoubleSide,
    
    // transparent: true,
  })
  const rbgeLoader = new RGBELoader()
  rbgeLoader.loadAsync("/src/assets/hdr/2k.hdr").then((texture: any) => {
    texture.mapping = THREE.EquirectangularReflectionMapping;
    scene.background = texture;
    scene.environment = texture;
  })

  const textureLoader = new THREE.TextureLoader();
  const gltfLoader = new GLTFLoader();
  gltfLoader.load("/src/assets/model/newyears_min.glb", (gltf: any) => {
  console.log(gltf);
  scene.add(gltf.scene);

  const waterGeometry = new THREE.PlaneGeometry(100, 100);
  const water = new Water(waterGeometry, {
    color: 0xeeeeff,
    scale: 1,
    // flowDirection: new THREE.Vector2(1, 1),
    textureHeight: 1024,
    textureWidth: 1024,
    normalMap1: textureLoader.load("/src/assets/imgs/Water_1_M_Normal.jpg"),
     normalMap2: textureLoader.load("/src/assets/imgs/Water_2_M_Normal.jpg"),

  });
  water.position.y = 1;
		water.rotation.x = Math.PI * - 0.5;
  scene.add(water);
 
});

 
  // 添加控制器
  const controls = new OrbitControls(camera, renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  renderer.setClearColor("#000");
  

const clock = new THREE.Clock();
  const render = () => {
    const elapsedTime = clock.getElapsedTime();
   
 fireworks.forEach((item, i) => {
    const type = item.update();
    if (type == "remove") {
      fireworks.splice(i, 1);
    }
  });
   
    renderer.render(scene, camera);
    controls.update();
    requestAnimationFrame(render);
  };
  window.addEventListener("resize", () => {
    renderer.setSize(window.innerWidth, window.innerHeight);
    camera.aspect = window.innerWidth / window.innerHeight;
    camera.updateProjectionMatrix();
  });
  render();
  containerRef.value.appendChild(renderer.domElement);
});

// 设置创建烟花函数
let createFireworks = () => {
  let color = `hsl(${Math.floor(Math.random() * 360)},100%,80%)`;
  let position = {
    x: (Math.random() - 0.5) * 40,
    z: -(Math.random() - 0.5) * 40,
    y: 3 + Math.random() * 15,
  };

  // 随机生成颜色和烟花放的位置
  let firework = new FireWork(color, position);
  firework.addScene(scene, camera);
  fireworks.push(firework);
 };
// 监听点击事件
window.addEventListener("click", createFireworks);
</script>
