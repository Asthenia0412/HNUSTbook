import { createRouter, createWebHistory } from 'vue-router'
import MainPage from '@/views/MainPage.vue'
import BackEndJava from '../views/BackEndJava.vue'
const router = createRouter({
  history: createWebHistory(import.meta.env.BASE_URL),
  routes: [
    {
      path:'/',
      redirect: 'home'//实现进入网站默认定向到home页面
    },
    {
      path: '/home',
      name: 'home',
      component: MainPage
    },
    {
      path: '/BackEndJava',
      name: 'BackEndJava',
      // route level code-splitting
      // this generates a separate chunk (About.[hash].js) for this route
      // which is lazy-loaded when the route is visited.
      component: BackEndJava
    }
  ]
})

export default router
