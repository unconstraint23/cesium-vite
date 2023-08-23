<template>
  <div>
    <div ref="containerRef" class="container"></div>
    <div class="label" ref="earthRef">地球</div>
    <div class="label" ref="moonRef">月球</div>
    <div class="label1" ref="chinaRef">中国</div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";

import {
  CSS2DRenderer,
  CSS2DObject,
} from "three/addons/renderers/CSS2DRenderer.js";

const containerRef = ref<any>(null);
const axesHelper = new THREE.AxesHelper(5);

let moon: any;

let chinaLabel: any;
const EARTH_RADIUS = 1;
const MOON_RADIUS = 0.27;
const raycaster = new THREE.Raycaster();
const earthRef = ref()
const moonRef = ref()
const chinaRef = ref()
onMounted(() => {
  const scene = new THREE.Scene();
  // 实例化css2d的渲染器
  let labelRenderer = new CSS2DRenderer();
  labelRenderer.setSize(window.innerWidth, window.innerHeight);
  const renderer = new THREE.WebGLRenderer({
    antialias: true,
    logarithmicDepthBuffer: true,
  });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.outputEncoding = THREE.sRGBEncoding;
  const textureLoader = new THREE.TextureLoader();

  const camera = new THREE.PerspectiveCamera(
    45,
    window.innerWidth / window.innerHeight,
    0.1,
    200
  );

  const dirLight = new THREE.DirectionalLight(0xffffff);
  dirLight.position.set(0, 0, 1);
  scene.add(dirLight);
  const light = new THREE.AmbientLight(0xffffff, 0.5); // soft white light
  scene.add(light);
  camera.position.set(0, 0, 10);
  scene.add(axesHelper);
  // 添加控制器
  const controls = new OrbitControls(camera, labelRenderer.domElement);
  controls.minDistance = 5;
  controls.maxDistance = 100;
  // 设置控制器阻尼
  controls.enableDamping = true;
  renderer.setClearColor("#000");

  const earthGeometry = new THREE.SphereGeometry(EARTH_RADIUS, 16, 16);
  const earthMaterial = new THREE.MeshPhongMaterial({
    specular: 0x333333,
    shininess: 5,
    map: textureLoader.load("/src/assets/imgs/earth_atmos_2048.jpg"),
    specularMap: textureLoader.load("/src/assets/imgs/earth_specular_2048.jpg"),
    normalMap: textureLoader.load("/src/assets/imgs/earth_normal_2048.jpg"),
    normalScale: new THREE.Vector2(0.85, 0.85),
  });

  const earth = new THREE.Mesh(earthGeometry, earthMaterial);
  earth.rotation.y = Math.PI;
  scene.add(earth);

  const moonGeometry = new THREE.SphereGeometry(MOON_RADIUS, 16, 16);
  const moonMaterial = new THREE.MeshPhongMaterial({
    shininess: 5,
    map: textureLoader.load("/src/assets/imgs/moon_1024.jpg"),
  });
  moon = new THREE.Mesh(moonGeometry, moonMaterial);
  scene.add(moon);

  // 添加提示标签
  // const earthDiv = document.createElement("div");
  // earthDiv.className = "label";
  // earthDiv.innerHTML = "地球";
  // earthRef.value = earthDiv
  const earthLabel = new CSS2DObject(earthRef.value);
  earthLabel.position.set(0, 1, 0);
  earth.add(earthLabel);

  // 中国
  // const chinaDiv = document.createElement("div");
  
  // chinaDiv.className = "label1";
  // chinaDiv.innerHTML = "中国";
  // chinaRef.value = chinaDiv
  chinaLabel = new CSS2DObject(chinaRef.value);
  chinaLabel.position.set(-0.3, 0.5, -0.9);
  earth.add(chinaLabel);
 

  // const moonDiv = document.createElement("div");
  // moonRef.value = moonDiv
  // moonDiv.className = "label";
  // moonDiv.innerHTML = "月球";
  const moonLabel = new CSS2DObject(moonRef.value);
  moonLabel.position.set(0, 0.3, 0);
  moon.add(moonLabel);

  
 
 
  labelRenderer.domElement.style.position = "fixed";
  labelRenderer.domElement.style.top = "0px";
  labelRenderer.domElement.style.left = "0px";
  labelRenderer.domElement.style.zIndex = "10";

  const clock = new THREE.Clock();


  const render = () => {
    const elapsedTime = clock.getElapsedTime();
    moon.position.set(Math.sin(elapsedTime) * 5, 0, Math.cos(elapsedTime) * 5);
    const chinaPosition = chinaLabel.position.clone();
    // 计算出标签跟摄像机的距离
    const labelDistance = chinaPosition.distanceTo(camera.position);
    // 检测射线的碰撞
    // chinaLabel.position
    // 向量(坐标)从世界空间投影到相机的标准化设备坐标 (NDC) 空间。
    chinaPosition.project(camera);
    raycaster.setFromCamera(chinaPosition, camera);

    const intersects = raycaster.intersectObjects(scene.children, true);
    // console.log(intersects)

    // 如果没有碰撞到任何物体，那么让标签显示
    if (intersects.length == 0) {
      chinaRef.value.classList.add("visible");
    } else {
      // if(labelDistance)
      const minDistance = intersects[0].distance;
      
      if (minDistance > labelDistance) {
        chinaRef.value.classList.remove("visible");
      } else {
        chinaRef.value.classList.add("visible");
      }
    }
    // 标签渲染器渲染
  labelRenderer.render(scene,camera);
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
  containerRef.value.appendChild(labelRenderer.domElement);
});
</script>
<style scoped lang="less">

  .label{
  color: #fff;
  font-size: 1rem;
}

.label1{
  color: #fff;
  display: none;
  font-size: 1rem;
}



.label1.visible{
  display: block;
}
</style>
