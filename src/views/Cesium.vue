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
  const layer = viewer.imageryLayers.addImageryProvider(
  new Cesium.IonImageryProvider({ assetId: 4 })
);

  //添加另外一个图层
// let layers = viewer.scene.imageryLayers
// let blackMarble = layers.addImageryProvider( new Cesium.TileMapServiceImageryProvider( {
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
  let geojsonOptions = {
        clampToGround : true
    };
    // 从 GeoJson 文件加载邻域边界
    // Data from : https://data.cityofnewyork.us/City-Government/Neighborhood-Tabulation-Areas/cpf4-rkhq
    let neighborhoodsPromise = Cesium.GeoJsonDataSource.load('/src/assets/SampleData/sampleNeighborhoods.geojson', geojsonOptions);
    let neighborhoods
    neighborhoodsPromise.then(function(dataSource) {
        // 将新数据作为实体添加到查看器
        viewer.dataSources.add(dataSource);
        neighborhoods = dataSource.entities;

        // Get the array of entities
        let neighborhoodEntities = dataSource.entities.values;
        for (let i = 0; i < neighborhoodEntities.length; i++) {
            let entity = neighborhoodEntities[i] as any;

            if (Cesium.defined(entity.polygon)) {
                // Use kml neighborhood value as entity name
                entity.name = entity.properties!.neighborhood;
                // Set the polygon material to a random, translucent color
                entity.polygon.material = Cesium.Color.fromRandom({
                    red : 0.1,
                    maximumGreen : 0.5,
                    minimumBlue : 0.5,
                    alpha : 0.6
                });
                // 告诉多边形为地形着色。 ClassificationType.CESIUM_3D_TILE 将为 3D 图块集着色，而 ClassificationType.BOTH 将为 3d 图块和地形着色（BOTH 是默认值）
                // Tells the polygon to color the terrain. ClassificationType.CESIUM_3D_TILE will color the 3D tileset, and ClassificationType.BOTH will color both the 3d tiles and terrain (BOTH is the default)
                entity.polygon.classificationType = Cesium.ClassificationType.TERRAIN;
                // 生成多边形中心
                var polyPositions = entity.polygon.hierarchy.getValue(Cesium.JulianDate.now()).positions;
                // 边界球
                var polyCenter = Cesium.BoundingSphere.fromPoints(polyPositions).center;
                // 椭球体
                polyCenter = Cesium.Ellipsoid.WGS84.scaleToGeodeticSurface(polyCenter);
                entity.position = polyCenter;
                // 生成标签
                entity.label = {
                    text : entity.name,
                    showBackground : true,
                    scale : 0.6,
                    horizontalOrigin : Cesium.HorizontalOrigin.CENTER,
                    verticalOrigin : Cesium.VerticalOrigin.BOTTOM,
                    distanceDisplayCondition : new Cesium.DistanceDisplayCondition(10.0, 8000.0),
                    disableDepthTestDistance : 100.0
                };
            }
        }
    });
    let kmlOptions = {
        camera : viewer.scene.camera,
        canvas : viewer.scene.canvas,
        // 如果我们想要将几何特征（多边形、线串和线性环）固定在地面上，则为 true。
        clampToGround : true
    };
    //KML文件是谷歌公司创建的一种地标性文件。
    //用于记录某一地点、或连续地点的时间、经度、纬度、海拔等地理信息数据，供GE等有关软件使用。
    // Load geocache points of interest from a KML file
    // Data from : http://catalog.opendata.city/dataset/pediacities-nyc-neighborhoods/resource/91778048-3c58-449c-a3f9-365ed203e914
    let geocachePromise = Cesium.KmlDataSource.load('/src/assets/SampleData/sampleGeocacheLocations.kml', kmlOptions);
    geocachePromise.then((dataSource: any) => {
        // 将新数据作为实体添加到查看器
        viewer.dataSources.add(dataSource);

        // 获取实体数组
        let geocacheEntities = dataSource.entities.values;

        for (let i = 0; i < geocacheEntities.length; i++) {
            let entity = geocacheEntities[i];
            if (Cesium.defined(entity.billboard)) {
                // 调整垂直原点，使图钉位于地形上
                entity.billboard.verticalOrigin = Cesium.VerticalOrigin.BOTTOM;
                entity.billboard.image = '/src/assets/tagpark.png'
                // 禁用标签以减少混乱
                entity.label = undefined;
                // 添加距离显示条件
                entity.billboard.distanceDisplayCondition = new Cesium.DistanceDisplayCondition(10.0, 20000.0);
                // 以度为单位计算纬度和经度
                let cartographicPosition = Cesium.Cartographic.fromCartesian(entity.position.getValue(Cesium.JulianDate.now()));
                let latitude = Cesium.Math.toDegrees(cartographicPosition.latitude);
                let longitude = Cesium.Math.toDegrees(cartographicPosition.longitude);
                // 修改描述
                let description = '<table class="cesium-infoBox-defaultTable cesium-infoBox-defaultTable-lighter"><tbody>' +
                    '<tr><th>' + "Longitude" + '</th><td>' + longitude.toFixed(5) + '</td></tr>' +
                    '<tr><th>' + "Latitude" + '</th><td>' + latitude.toFixed(5) + '</td></tr>' +
                    '<tr><th>' + "实时人流" + '</th><td>' + Math.floor(Math.random()*20000)  + '</td></tr>' +
                    '<tr><th>' + "安全等级" + '</th><td>' + Math.floor(Math.random()*5)  + '</td></tr>' +
                    '</tbody></table>';
                entity.description = description;
            }
        }
    });
     // 从czml文件加载飞行路径
  var dronePromise = Cesium.CzmlDataSource.load('/src/assets/SampleData/sampleFlight.czml');

// 无人机实体
let drone: any;
dronePromise.then((dataSource) => {
  viewer.dataSources.add(dataSource);
  drone = dataSource.entities.getById('Aircraft/Aircraft1');
  drone.model = {
    uri:'/src/assets/SampleData/Models/CesiumDrone.gltf',
    // uri:'/src/assets/SampleData/Models/ferrari2.gltf',
    // minimumPixelSize: 128,
    // maximumScale:1000,
    // silhouetteColor:Cesium.Color.WHITE,
    // silhouetteSize:2
  }

  drone.orientation = new Cesium.VelocityOrientationProperty(drone.position);
  drone.viewFrom = new Cesium.Cartesian3(0,-30,30)
  viewer.clock.shouldAnimate = true;
})
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