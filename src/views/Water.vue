<template>
  <div>
    <div ref="containerRef" class="container"></div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";
import { RGBELoader } from "three/examples/jsm/loaders/RGBELoader";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import { Water } from "three/examples/jsm/objects/Water2";
const containerRef = ref<any>(null);
    const axesHelper = new THREE.AxesHelper(5);
onMounted(() => {
  const scene = new THREE.Scene();
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    logarithmicDepthBuffer: true,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.outputEncoding = THREE.sRGBEncoding;

  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  );
  camera.position.set(0, 0, 10);
  scene.add(axesHelper)
  // 添加控制器
  const controls = new OrbitControls(camera, renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  renderer.setClearColor("#000");
  const rbgeLoader = new RGBELoader()
  rbgeLoader.loadAsync("/src/assets/hdr/050.hdr").then((texture: any) => {
    texture.mapping = THREE.EquirectangularReflectionMapping;
    scene.background = texture;
    scene.environment = texture;
  })
  const textureLoader = new THREE.TextureLoader();
  const gltfLoader = new GLTFLoader();
  let LightBox = null;
  gltfLoader.load("/src/assets/model/yugang.glb", (gltf: any) => {
    console.log(gltf);
  const yugang = gltf.scene.children[0];
  yugang.material.side = THREE.DoubleSide;
    
  const waterGeometry = gltf.scene.children[1].geometry;
  const water = new Water(waterGeometry, {
    color: 0xeeeeff,
    scale: 1,
    flowDirection: new THREE.Vector2(1, 1),
    textureHeight: 1024,
    textureWidth: 1024,
    normalMap1: textureLoader.load("/src/assets/imgs/Water_1_M_Normal.jpg"),
     normalMap2: textureLoader.load("/src/assets/imgs/Water_2_M_Normal.jpg"),

  });
  // water.position.y = 1;
	// 	water.rotation.x = Math.PI * - 0.5;
  scene.add(water);
  scene.add(yugang);
});

const clock = new THREE.Clock();
  const render = () => {
    const elapsedTime = clock.getElapsedTime();

   
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
</script>
