import {createRouter,createWebHashHistory} from 'vue-router'
const routes = [
    {
        path: '/cesium',
         component: () => import("../views/Cesium.vue"),
    },
    {
        path: '/shader',
         component: () => import("../views/Shader.vue"),
    },
    {
        path: '/meshShader',
         component: () => import("../views/MeshShader.vue"),
    },
    {
        path: '/deepShader',
         component: () => import("../views/DeepShader.vue"),
    },
    {
        path: '/lantern',
         component: () => import("../views/Lantern.vue"),
    },
    {
        path: '/fireWork',
         component: () => import("../views/FireWork.vue"),
    },
    {
        path: '/water',
         component: () => import("../views/Water.vue"),
    },
    {
        path: '/particle',
         component: () => import("../views/Particle.vue"),
    },
    { path: '/', redirect: '/cesium' }

]

// 3. 创建路由实例并传递 `routes` 配置
// 你可以在这里输入更多的配置，但我们在这里
// 暂时保持简单
const router = createRouter({
    // 4. 内部提供了 history 模式的实现。为了简单起见，我们在这里使用 hash 模式。
    history: createWebHashHistory(),
    routes, // `routes: routes` 的缩写
})
export default router

