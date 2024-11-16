import { createApp } from 'vue'
import './style.css'
import App from '/src/App.vue'
import router from "/src/router/router.js";
import Register from '/src/pages/LoginAndRegister/Register.vue'
import Login from '/src/pages/LoginAndRegister/Login.vue'
import AdminOperation from '/src/pages/Operation/AdminOperation.vue'
import PersonOperation from '/src/pages/Operation/PersonOperation.vue'
import SelfInformation from '/src/pages/Self/SelfInformation.vue'
import Information from "./components/Column/Information.vue";
import Navigation from "./components/Column/Navigation.vue";
import Main from "./pages/MainPage/Main.vue";
import Flex from "./components/Tips/Flex.vue";
import Blog from "./pages/Blog/Blog.vue";
const app = createApp(App);
import '@arco-design/web-vue/dist/arco.css';
import ArcoVue from "@arco-design/web-vue";
import axios from 'axios'

app.use(ArcoVue);
app.use(router); // 使用正确的实例调用 use 方法
app.use(axios) // 使用 axios 插件

app.component('Register', Register)
app.component('Login', Login)
app.component('AdminOperation', AdminOperation)
app.component('PersonOperation', PersonOperation)
app.component('SelfInformation', SelfInformation)
app.component('Information',Information)
app.component('Navigation',Navigation)
app.component('Flex',Flex)
app.component('Main',Main)
app.mount("#app");
app.component('Blog',Blog)
