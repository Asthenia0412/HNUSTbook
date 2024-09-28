import Vue from 'vue'
import Router from 'vue-router'
import Layout from '@/layout/index'
import InkPainting from '@/components/ink-painting'
import PersonalCenter from '@/components/personal-center'
import PointMall from '@/components/Pointmall'
import WonderfulArticles from '@/components/wonderful-articles'

Vue.use(Router)

export default new Router({
  routes: [
    {
      path: '/',
      name: 'Layout',
      component: Layout
    },
    {
      path: '/personal-center',
      name: 'PersonalCenter',
      component: PersonalCenter
    },
    {
      path: '/wonderful-articles',
      name: 'WonderfulArticles',
      component: WonderfulArticles
    },
    {
      path: '/pointmall',
      name: 'PointMall',
      component: PointMall
    },
    {
      path: '/ink-painting',
      name: 'InkPainting',
      component: InkPainting
    }
  ]
})
