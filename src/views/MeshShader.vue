<template>
  <div>
    <div ref="containerRef" class="container"></div>
  </div>
</template>

<script lang="ts" setup>
import { onMounted, ref } from "vue";

import * as THREE from "three";
import { OrbitControls } from "three/addons/controls/OrbitControls";
import { GLTFLoader } from "three/examples/jsm/loaders/GLTFLoader";

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

  const customUniforms = {
  uTime : {
    value:0
  }
}
  // 加载模型纹理
  const modelTexture = textureLoader.load('/src/assets/imgs/color.jpg');
  // 加载模型的法向纹理
  const normalTexture = textureLoader.load('/src/assets/imgs/normal.jpg')

  const material = new THREE.MeshStandardMaterial({
    map:modelTexture,
    normalMap:normalTexture
  })

  material.onBeforeCompile = (shader: any)=>{
  
  // 传递时间
  shader.uniforms.uTime = customUniforms.uTime;
  shader.vertexShader = shader.vertexShader.replace(
    '#include <common>',
    `
    #include <common>
    mat2 rotate2d(float _angle){
      return mat2(cos(_angle),-sin(_angle),
                  sin(_angle),cos(_angle));
    }
    uniform float uTime;
    `
  )
    
  shader.vertexShader = shader.vertexShader.replace(
    '#include <beginnormal_vertex>',
    `
    #include <beginnormal_vertex>
    float angle = sin(position.y+uTime) *0.5;
    mat2 rotateMatrix = rotate2d(angle);
    
    
    objectNormal.xz = rotateMatrix * objectNormal.xz;
    `
  )
  shader.vertexShader = shader.vertexShader.replace(
    '#include <begin_vertex>',
    `
    #include <begin_vertex>
    // float angle = transformed.y*0.5;
    // mat2 rotateMatrix = rotate2d(angle);
    
    
    transformed.xz = rotateMatrix * transformed.xz;


    `
  )
}

  const depthMaterial = new THREE.MeshDepthMaterial({
  depthPacking:THREE.RGBADepthPacking
  })

  depthMaterial.onBeforeCompile = (shader: any)=>{
     // 传递时间
  shader.uniforms.uTime = customUniforms.uTime;
  shader.vertexShader = shader.vertexShader.replace(
    '#include <common>',
    `
    #include <common>
    mat2 rotate2d(float _angle){
      return mat2(cos(_angle),-sin(_angle),
                  sin(_angle),cos(_angle));
    }
    uniform float uTime;
    `
  );
  shader.vertexShader = shader.vertexShader.replace(
    '#include <begin_vertex>',
    `
    #include <begin_vertex>
    float angle = sin(position.y+uTime) *0.5;
    mat2 rotateMatrix = rotate2d(angle);
    
    
    transformed.xz = rotateMatrix * transformed.xz;


    `
  )

}
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
  // 添加环境纹理
const cubeTextureLoader = new THREE.CubeTextureLoader();
const envMapTexture = cubeTextureLoader.load([
  "/src/assets/imgs/0/px.jpg",
  "/src/assets/imgs/0/nx.jpg",
  "/src/assets/imgs/0/py.jpg",
  "/src/assets/imgs/0/ny.jpg",
  "/src/assets/imgs/0/pz.jpg",
  "/src/assets/imgs/0/nz.jpg",
]);

const directionLight = new THREE.DirectionalLight('#ffffff',1);
directionLight.castShadow = true;
directionLight.position.set(0,0,100)
scene.add(directionLight)


scene.environment = envMapTexture;
scene.background = envMapTexture;

// 模型加载
const gltfLoader = new GLTFLoader();
gltfLoader.load('/src/assets/model/LeePerrySmith.glb',(gltf: any)=>{
  // console.log(gltf)
  const mesh = gltf.scene.children[0];
  console.log(mesh)
  mesh.material = material;
  mesh.castShadow = true;
  // 设定自定义的深度材质
  mesh.customDepthMaterial = depthMaterial;
  scene.add(mesh);
})

const plane = new THREE.Mesh(
  new THREE.PlaneGeometry(20,20),
  new THREE.MeshStandardMaterial()
)
plane.position.set(0,0,-6);
plane.receiveShadow = true;
scene.add(plane)


const clock = new THREE.Clock();
renderer.shadowMap.enabled = true;
  const render = () => {
    const elapsedTime = clock.getElapsedTime();
    
    customUniforms.uTime.value = elapsedTime;
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
