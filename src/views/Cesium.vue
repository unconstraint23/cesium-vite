<template>
    <div id="cesiumContainer">

    </div>
</template>

<script setup lang="ts">
import * as Cesium from 'cesium'
import { onMounted } from 'vue'
// import "cesium/Build/Cesium/Widgets/widgets.css";
Cesium.Ion.defaultAccessToken = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJqdGkiOiIzYmQxODY1Ni00NGY5LTRlYzEtOWRkYy1iZjNkNTYzMmU3ZjAiLCJpZCI6MTMxMTI3LCJpYXQiOjE2ODAwNzk3NjR9.Pbct9YXdWDOg8r7Zba9DXrrj1UDSl6C14I3i-hMXN2E'
onMounted(() => {
    // const viewer = new Cesium.Viewer('cesiumContainer')
    
    const custom = new Cesium.ArcGisMapServerImageryProvider({
    url: '//services.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer'
  })
  // const custom = new Cesium.BingMapsImageryProvider({
  //   url : 'https://dev.virtualearth.net',
  //   key : 'get-yours-at-https://www.bingmapsportal.com/',
  //   mapStyle : Cesium.BingMapsStyle.AERIAL});
//   const imageryProvider = new Cesium.WebMapTileServiceImageryProvider({
//     url : 'http://t0.tianditu.com/img_w/wmts?',
//     layer : 'img',
//     style : 'default',
//     format : 'tiles',
//     tileMatrixSetID : 'w',
//     // tileMatrixLabels : ['default028mm:0', 'default028mm:1', 'default028mm:2' ...],
//     maximumLevel: 18,
//     credit : new Cesium.Credit('天地图')
// });
  const viewer = new Cesium.Viewer('cesiumContainer', {
    // 不创建baseLayerPicker小部件
    baseLayerPicker: false,
    infoBox: false,
    // 设置图像提供的程序
    imageryProvider: custom,
    // 设置cesium世界地形
    terrainProvider:Cesium.createWorldTerrain({
      requestWaterMask:true,
      requestVertexNormals:true,
    })
  })
  //添加另外一个图层
// let layers = viewer.scene.imageryLayers
// var blackMarble = layers.addImageryProvider( new Cesium.TileMapServiceImageryProvider( {
//     url : '//cesiumjs.org/tilesets/imagery/blackmarble',
//     maximumLevel : 8,
//     credit : 'Black Marble imagery courtesy NASA Earth Observatory'
// } ) );
// //设置图层的透明度
// blackMarble.alpha = 0.5;
// //设置图层的亮度
// blackMarble.brightness = 2.0;
// //添加一个图层，在特定位置绘制一个图片
// layers.addImageryProvider(new Cesium.SingleTileImageryProvider({
//     url : '/src/assets/imgs/match.jpg',
//     rectangle : Cesium.Rectangle.fromDegrees(-75,23,20,29.96)
// }));
//   //全球影像中文注记服务
// viewer.imageryLayers.addImageryProvider(new Cesium.WebMapTileServiceImageryProvider({
//     url: "http://t0.tianditu.com/cia_w/wmts?service=wmts&request=GetTile&version=1.0.0&LAYER=cia&tileMatrixSet=w&TileMatrix={TileMatrix}&TileRow={TileRow}&TileCol={TileCol}&style=default.jpg",
//     layer: "tdtAnnoLayer",
//     style: "default",
//     format: "image/jpeg",
//     tileMatrixSetID: "GoogleMapsCompatible",
//     show: false
// }));
//   viewer.imageryLayers.addImageryProvider(imageryProvider);
  // const buildingTileset = viewer.scene.primitives.add(Cesium.createOsmBuildings());
  viewer.camera.setView({
    destination: new Cesium.Cartesian3(1332761,-4662399,4137888),
    orientation:{
      heading:0.60,
      pitch:-0.66
    }

    
  })
//   const layer = viewer.imageryLayers.addImageryProvider(
//   new Cesium.IonImageryProvider({ assetId: 4 })
// );
  const city = viewer.scene.primitives.add(new Cesium.Cesium3DTileset({url:Cesium.IonResource.fromAssetId(96188)}));
  
  // 定义3d样式
  const heightStyle = new Cesium.Cesium3DTileStyle({
    defines: {
    distanceFromComplex:
      "distance(vec2(${feature['cesium#longitude']}, ${feature['cesium#latitude']}), vec2(144.96007, -37.82249))",
  },
  color: {
    conditions: [
      ["${distanceFromComplex} > 0.010", "color('#d65c5c')"],
      ["${distanceFromComplex} > 0.006", "color('#f58971')"],
      ["${distanceFromComplex} > 0.002", "color('#f5af71')"],
      ["${distanceFromComplex} > 0.0001", "color('#f5ec71')"],
      ["true", "color('#ffffff')"],
    ],
  },
  })
  console.log(city)
  city.style = heightStyle;
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