<template>
    <div id="cesiumContainer">

    </div>
</template>

<script setup lang="ts">
import * as Cesium from 'cesium'
import { onMounted } from 'vue'
onMounted(() => {
    const viewer = new Cesium.Viewer('cesiumContainer')
})
</script>

<style lang="less">
#cesiumContainer {
  width: 90%;
  height: 90%;
  margin: auto;
}
</style>