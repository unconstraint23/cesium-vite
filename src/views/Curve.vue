<template>
  <div>
    <div ref="containerRef" class="container"></div>
    
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


const EARTH_RADIUS = 1;
const MOON_RADIUS = 0.27;
const raycaster = new THREE.Raycaster();

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
  const controls = new OrbitControls(camera, renderer.domElement);
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
  moon.position.z = 4
  scene.add(moon);

  //根据这一系列的点创建曲线
  let curve = new THREE.CatmullRomCurve3(
    [
      new THREE.Vector3(-10, 0, 10),
      new THREE.Vector3(-5, 5, 5),
      new THREE.Vector3(0, 0, 5),
      new THREE.Vector3(5, -5, 5),
      new THREE.Vector3(10, 0, 10),
    ],
    true
  );

 // 在曲线里，getPoints获取51个点
 const points = curve.getPoints(500);
  console.log(points);
  const geometry = new THREE.BufferGeometry().setFromPoints(points);

  const material = new THREE.LineBasicMaterial({ color: 0xff0000 });

  // Create the final object to add to the scene
  const curveObject = new THREE.Line(geometry, material);
  scene.add(curveObject);

  
 

 

  
 
 

  const clock = new THREE.Clock();


  const render = () => {
    const elapsedTime = clock.getElapsedTime();
   

    const time = elapsedTime / 10 % 1;

    const point = curve.getPoint(time);
  
  moon.position.copy(point);
  
  camera.position.copy(point);
  camera.lookAt(earth.position)
   
    // 标签渲染器渲染

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
