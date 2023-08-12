<template>
  <div>
    <div ref="containerRef" class="container"></div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";
import vertexShader from '../shader/raw/vertex.glsl?raw'
import fragmentShader from '../shader/raw/fragment.glsl?raw'
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
  const rawShaderMaterial = new THREE.RawShaderMaterial({
    vertexShader: vertexShader,
    fragmentShader: fragmentShader
  })
// 创建平面
const floor = new THREE.Mesh(
  new THREE.PlaneGeometry(1, 1, 64, 64),
  rawShaderMaterial
);

console.log(floor);
scene.add(floor);
  const render = () => {
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
