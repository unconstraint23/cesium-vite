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
import Ca from '@/assets/imgs/ca.jpeg'
import { RGBELoader } from "three/examples/jsm/loaders/RGBELoader";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";
import gsap from "gsap";
const containerRef = ref<any>(null);
    const axesHelper = new THREE.AxesHelper(5);
onMounted(() => {
  const scene = new THREE.Scene();
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    logarithmicDepthBuffer: true,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  // renderer.outputColorSpace = THREE.sRGBEncoding;
  renderer.toneMappingExposure = 0.2;
  renderer.toneMapping = THREE.ACESFilmicToneMapping;
  const camera = new THREE.PerspectiveCamera(
    90,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  );
  camera.position.set(0, 0, 2);
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
  const gltfLoader = new GLTFLoader();
  let LightBox = null;
  gltfLoader.load("/src/assets/model/flyLight.glb", (gltf: any) => {
  console.log(gltf);

  LightBox = gltf.scene.children[0];
  LightBox.material = shaderMaterial;

  for (let i = 0; i < 150; i++) {
    let flyLight = gltf.scene.clone(true);
    let x = (Math.random() - 0.5) * 300;
    let z = (Math.random() - 0.5) * 300;
    let y = Math.random() * 60 + 25;
    flyLight.position.set(x, y, z);
    gsap.to(flyLight.rotation, {
      y: 2 * Math.PI,
      duration: 10 + Math.random() * 30,
      repeat: -1,
    });
    gsap.to(flyLight.position, {
      x: "+=" + Math.random() * 5,
      y: "+=" + Math.random() * 20,
      yoyo: true,
      duration: 5 + Math.random() * 10,
      repeat: -1,
    });
    scene.add(flyLight);
  }
  // scene.add(gltf.scene)
});
  // 添加控制器
  const controls = new OrbitControls(camera, renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  renderer.setClearColor("#000");
  

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
