import Vue from 'vue'
import App from './App.vue'
import router from './router'
import Ajax from "./axiosApi.js"

Vue.config.productionTip = false
Vue.prototype.$axios = Ajax

new Vue({
  router,
  render: h => h(App)
}).$mount('#app')
