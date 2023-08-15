<template>
  <div>
    <div ref="containerRef" class="container"></div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";
import vertexShader from '../shader/deep/vertex.glsl'
import fragmentShader from '../shader/deep/fragment.glsl'
import Ca from '@/assets/imgs/ca.jpeg'
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
  const textureLoader = new THREE.TextureLoader();
const texture = textureLoader.load(Ca);
  const camera = new THREE.PerspectiveCamera(
    90,
    window.innerWidth / window.innerHeight,
    0.1,
    1000
  );
  camera.position.set(0, 0, 2);
  scene.add(axesHelper)
  // 添加控制器
  const controls = new OrbitControls(camera, renderer.domElement);
  // 设置控制器阻尼
  controls.enableDamping = true;
  renderer.setClearColor("#000");
  const rawShaderMaterial = new THREE.RawShaderMaterial({
    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    side: THREE.DoubleSide,
    uniforms: {
      uTime: {
        value: 0
      },
      uFrequency: {
        value: new THREE.Vector2(10, 5)
      },
      uTexture: {
        value: texture
      }
    },
    transparent: true,
  })
// 创建平面
const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(2, 2, 64, 64),
  rawShaderMaterial
);


scene.add(floor);
const clock = new THREE.Clock();
  const render = () => {
    const elapsedTime = clock.getElapsedTime();
    rawShaderMaterial.uniforms.uTime.value = elapsedTime
   
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
