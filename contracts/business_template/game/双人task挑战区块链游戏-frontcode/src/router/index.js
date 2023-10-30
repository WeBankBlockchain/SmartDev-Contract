import Vue from 'vue'
import VueRouter from 'vue-router'
import HomeIndex from '../views/HomeIndex.vue'

Vue.use(VueRouter)

const routes = [
  {
    path: '/',
    name: 'HomeIndex',
    component: HomeIndex
  },

]

const router = new VueRouter({
  routes
})

export default router
