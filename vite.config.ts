import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import cesium from 'vite-plugin-cesium';
import glsl from 'vite-plugin-glsl'; 
import path from 'path'
// https://vitejs.dev/config/
export default defineConfig({
  plugins: [vue(),
          cesium(),
          glsl()
    ],
    resolve: {
      alias: [
       { find: '@', replacement: path.resolve(__dirname, './src') }
      ]
    },
})
