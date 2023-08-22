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
// 导入后期效果合成器
import {EffectComposer} from 'three/examples/jsm/postprocessing/EffectComposer';
import * as dat from "dat.gui";
// three框架本身自带效果
import {RenderPass} from 'three/examples/jsm/postprocessing/RenderPass';
import {DotScreenPass} from 'three/examples/jsm/postprocessing/DotScreenPass';
import {SMAAPass} from 'three/examples/jsm/postprocessing/SMAAPass'
import {SSAARenderPass} from 'three/examples/jsm/postprocessing/SSAARenderPass'
import {GlitchPass} from 'three/examples/jsm/postprocessing/GlitchPass'
import {UnrealBloomPass} from 'three/examples/jsm/postprocessing/UnrealBloomPass'
import {ShaderPass} from 'three/examples/jsm/postprocessing/ShaderPass'


const gui = new dat.GUI();
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
 

 






  const camera = new THREE.PerspectiveCamera(
    75,
    window.innerWidth / window.innerHeight,
    0.1,
    50
  );
  camera.position.set(0, 0, 5);
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
directionLight.position.set(0,0,50)
scene.add(directionLight)


scene.environment = envMapTexture;
scene.background = envMapTexture;

// 模型加载
const gltfLoader = new GLTFLoader();

gltfLoader.load('/src/assets/model/gltf/DamagedHelmet.gltf',(gltf: any)=>{

  const mesh = gltf.scene.children[0];
  
  
  scene.add(mesh)
})


// 合成效果
const effectComposer = new EffectComposer(renderer);
effectComposer.setSize(window.innerWidth, window.innerHeight);

// 添加渲染通道
const renderPass = new RenderPass(scene,camera);
effectComposer.addPass(renderPass)

// 点效果
const dotScreenPass = new DotScreenPass();
dotScreenPass.enabled = false;
effectComposer.addPass(dotScreenPass )


// 抗锯齿
const smaaPass = new SMAAPass();
effectComposer.addPass(smaaPass)

// 发光效果
const unrealBloomPass = new UnrealBloomPass();
effectComposer.addPass(unrealBloomPass)

// 屏幕闪动
// const glitchPass = new GlitchPass();
// effectComposer.addPass(glitchPass)

// unrealBloomPass.exposure = 1;
renderer.toneMapping = THREE.ACESFilmicToneMapping;
renderer.toneMappingExposure = 1;
unrealBloomPass.strength = 1;
unrealBloomPass.radius = 0;
unrealBloomPass.threshold = 1;

gui.add(renderer,'toneMappingExposure').min(0).max(2).step(0.01)
gui.add(unrealBloomPass,'strength').min(0).max(2).step(0.01)
gui.add(unrealBloomPass,'radius').min(0).max(2).step(0.01)
gui.add(unrealBloomPass,'threshold').min(0).max(2).step(0.01)

const colorParams = {
  r:0,
  g:0,
  b:0
}

// 着色器写渲染通道
const shaderPass = new ShaderPass(
  {
    uniforms:{
      tDiffuse:{
        value:null
      },
      uColor:{
        value:new THREE.Color(colorParams.r,colorParams.g,colorParams.b)
      }
    },
    vertexShader:`
      varying vec2 vUv;
      void main(){
        vUv = uv;
        gl_Position = projectionMatrix*modelViewMatrix*vec4(position,1.0);
      }
    `,
    fragmentShader:`
      varying vec2 vUv;
      uniform sampler2D tDiffuse;
      uniform vec3 uColor;
      void main(){
        vec4 color = texture2D(tDiffuse,vUv);
        // gl_FragColor = vec4(vUv,0.0,1.0);
        color.xyz+=uColor;
        gl_FragColor = color;
      }
    `
  },

)

effectComposer.addPass(shaderPass);

gui.add(colorParams,'r').min(-1).max(1).step(0.01).onChange((value: any)=>{
  shaderPass.uniforms.uColor.value.r = value;
});
gui.add(colorParams,'g').min(-1).max(1).step(0.01).onChange((value: any)=>{
  shaderPass.uniforms.uColor.value.g = value;
});
gui.add(colorParams,'b').min(-1).max(1).step(0.01).onChange((value: any)=>{
  shaderPass.uniforms.uColor.value.b = value;
})


const normalTexture = textureLoader.load('/src/assets/imgs/interfaceNormalMap.png');

const techPass = new ShaderPass({
  uniforms:{
    tDiffuse:{
      value:null
    },
    uNormalMap:{
      value:null
    },
    uTime:{
      value:0
    }
  },
  vertexShader:`
    varying vec2 vUv;
    void main(){
      vUv = uv;
      gl_Position = projectionMatrix*modelViewMatrix*vec4(position,1.0);
    }
  `,
  fragmentShader:`
    varying vec2 vUv;
    uniform sampler2D tDiffuse;
    uniform sampler2D uNormalMap;
    uniform float uTime;
    void main(){

      vec2 newUv = vUv;
      newUv += sin(newUv.x*10.0+uTime*0.5)*0.03;

      vec4 color = texture2D(tDiffuse,newUv);
      // gl_FragColor = vec4(vUv,0.0,1.0);
      vec4 normalColor = texture2D(uNormalMap,vUv);
      // 设置光线的角度
      vec3 lightDirection = normalize(vec3(-5,5,2)) ;

      float lightness = clamp(dot(normalColor.xyz,lightDirection),0.0,1.0) ;
      color.xyz+=lightness;
      gl_FragColor = color;
    }
  `
})
techPass.material.uniforms.uNormalMap.value = normalTexture;
effectComposer.addPass(techPass);
const clock = new THREE.Clock();
renderer.shadowMap.enabled = true;
  const render = () => {
    const elapsedTime = clock.getElapsedTime();
    
    customUniforms.uTime.value = elapsedTime;
    renderer.render(scene, camera);
    controls.update();
    requestAnimationFrame(render);
    techPass.material.uniforms.uTime.value = elapsedTime;
  effectComposer.render()
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
