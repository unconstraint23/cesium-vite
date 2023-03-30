<template>
    <div id="cesiumContainer">

    </div>
</template>

<script setup lang="ts">
import * as Cesium from 'cesium'
import { onMounted } from 'vue'
import "cesium/Build/Cesium/Widgets/widgets.css";
Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzYmQxODY1Ni00NGY5LTRlYzEtOWRkYy1iZjNkNTYzMmU3ZjAiLCJpZCI6MTMxMTI3LCJpYXQiOjE2ODAwNzk3NjR9.Pbct9YXdWDOg8r7Zba9DXrrj1UDSl6C14I3i-hMXN2E'
onMounted(() => {
    // const viewer = new Cesium.Viewer('cesiumContainer')
    
    const custom = new Cesium.ArcGisMapServerImageryProvider({
    url: '//services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer'
  })
 
  const viewer = new Cesium.Viewer('cesiumContainer',{
    // 不创建baseLayerPicker小部件
    baseLayerPicker:false,
    infoBox: false,
    // 设置图像提供的程序
    imageryProvider: custom,
    // 设置cesium世界地形
    terrainProvider:Cesium.createWorldTerrain({
      requestWaterMask:true,
      requestVertexNormals:true,
    })
  })
  const buildingTileset = viewer.scene.primitives.add(Cesium.createOsmBuildings());
  viewer.camera.setView({
    destination: Cesium.Cartesian3.fromDegrees(113.318977,23.114155,2000),
    orientation:{
      heading: Cesium.Math.toRadians(90.0),
      pitch: Cesium.Math.toRadians(-45),
    }

    
  })

  // const city = viewer.scene.primitives.add(new Cesium.Cesium3DTileset({url:Cesium.IonResource.fromAssetId(3839)}));
  
  // 定义3d样式
//   const heightStyle = new Cesium.Cesium3DTileStyle({
//     color:{
//       // 条件判断具体的颜色
//       conditions:[
//         ['${height} >= 300','rgba(45,0,75,0.5)'],
//         ['${height} >= 200','rgb(102,71,151)'],
//         ['${height} >= 100','rgba(170,162,204,0.5)'],
//         ['${height} >= 50','rgba(224,226,238,0.5)'],
//         ['${height} >= 25','rgba(252,230,200,0.5)'],
//         ['${height} >= 10','rgba(248,176,87,0.5)'],
//         ['${height} >= 5','rgba(198,106,11,0.5)'],
//         ["true","rgb(127,59,8)"]
//       ]
//     }
//   })

//   city.style = heightStyle;
})
</script>

<style lang="less">
#cesiumContainer {
  width: 100%;
  height: 100%;
  margin: 0;
  padding: 0;
  overflow: hidden;
}
</style>