import { defineConfig } from 'vite';
import vue from '@vitejs/plugin-vue'; // 导入 Vue 插件

// https://vite.dev/config/
export default defineConfig({
  plugins: [vue()], // 在 plugins 数组中添加 vue 插件
  server: {
    proxy: {
      // 配置代理，将前端请求的接口路径代理到后端的 localhost:8080 上
      '/Admin': {
        target: 'http://localhost:8080/Admin', // 后端服务的地址
        changeOrigin: true, // 是否改变请求头中的Origin字段
        rewrite: (path) => path.replace(/^\/Admin/, ''), // 重写路径，去掉前缀
      },
      '/User': {
        target: 'http://localhost:8080/User', // 后端服务的地址
        changeOrigin: true, // 是否改变请求头中的Origin字段
        rewrite: (path) => path.replace(/^\/User/, '')

      }
      ,
      '/Discuss': {
        target: 'http://localhost:8080/Discuss', // 后端服务的地址
        changeOrigin: true, // 是否改变请求头中的Origin字段
        rewrite: (path) => path.replace(/^\/Discuss/, ''), // 重写路径，去掉前缀
      }
    }}}
);
