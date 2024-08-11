## 1.组件注册问题：

在App.vue中引入MainPage.vue.不能在setup中注册.而是使用export default 然后在components中注册

```vue
<script>
import {RouterLink,RouterView} from 'vue-router'
import MainPage from './views/MainPage.vue'
export default{
    name:'App',
    components:{
        MainPage
    },
    setup(){
        
    }
}
</script>
<template>
<MainPage></MainPage>
</template>
```

## 2.使用Element-UI

```
npm install element-plus --save
npm install -D unplugin-vue-components unplugin-auto-import

```

```js
import ElementPlus from 'element-plus'
import 'element-plus/dist/index.css'
import App from './App.vue';
const app = createApp(App)
app.use(ElementPlus)
app.mount('#app')
```

## 3.MainPage的背景和BackEndJava中背景发生重复

我不需要背景出现在BackEndJava中，发现背景是通过css实现的导入，而我没有在MainPage.vue的style添加scoped标签

```vue
<style scoped>

.flex-grow {
    flex-grow: 1;
    position: fixed;
    top:0;
    left:0;
}

#building{
background:url("../bg.png");
width:100%;		
height:100%;			
position:fixed;
background-size: 100% 100%;}



</style>
```

## 4.封装导航栏到一个Components中的Nav里面

> 切记 要使用export default 不要用setup! setup导出这里频繁出错

```vue
<template>
    <div class="flex-grow" id="building">
        <el-menu
      :default-active="activeIndex"
      class="el-menu-demo"
      mode="horizontal"
      :ellipsis="false"
      @select="handleSelect"
 
    >
      <el-menu-item index="0">
        <p>XiaoYongCai的个人博客</p>
      </el-menu-item>

      <el-sub-menu index="1">
        <template #title>后端技术栈</template>
        <el-menu-item index="/BackEndJava">JavaSE</el-menu-item>
        <el-menu-item index="/SSM">SSM+SpringBoot学习</el-menu-item>
        <el-menu-item index="/mirco">分布式微服务</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="2">
        <template #title>前端技术栈</template>
        <el-menu-item index="/HtmlCssJs">HTML/CSS/JS</el-menu-item>
        <el-menu-item index="/Vue">Vue与生态</el-menu-item>
        <el-menu-item index="/React">React与生态</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="3">
        <template #title>数据结构与算法</template>
        <el-menu-item index="/Algorithm">常见数据结构的实现</el-menu-item>
        <el-menu-item index="/AInterview">面试常考算法</el-menu-item>
        <el-menu-item index="/ARecord">一些罕见而有趣的算法记录</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="4">
        <template #title>计算机网络笔记</template>
        <el-menu-item index="4-2">待定</el-menu-item>
        <el-menu-item index="4-2">待定</el-menu-item>
        <el-menu-item index="4-3">待定</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="5">
        <template #title>操作系统笔记</template>
        <el-menu-item index="5-1">待定</el-menu-item>
        <el-menu-item index="5-2">待定</el-menu-item>
        <el-menu-item index="5-3">item three</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="6">
        <template #title>数据库笔记</template>
        <el-menu-item index="6-1">Mysql</el-menu-item>
        <el-menu-item index="6-2">Redis</el-menu-item>
        <el-menu-item index="6-3">MongoDB</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="7">
        <template #title>计算机系课程笔记</template>
        <el-menu-item index="/Math">数学类</el-menu-item>
        <el-menu-item index="/Electric">电学类</el-menu-item>
        <el-menu-item index="/Encoding">编码类</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="8">
        <template #title>生活随笔</template>
        <el-menu-item index="/Chuzhong">初中随笔-九中时光</el-menu-item>
        <el-menu-item index="/Gaozhong">高中随笔-十五朝阳</el-menu-item>
        <el-menu-item index="/HNUST">大学随笔-科大回望</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="9">
        <template #title>技术历程</template>
        <el-menu-item index="/EFront">前端技术历程</el-menu-item>
        <el-menu-item index="/EBack">后端技术历程</el-menu-item>
        <el-menu-item index="/EFull">全栈经历分享</el-menu-item>
      </el-sub-menu>
      <el-sub-menu index="10">
        <template #title>旅途留影</template>
        <el-menu-item index="/PChild">儿时回忆</el-menu-item>
        <el-menu-item index="/PTeenager">少年意气</el-menu-item>
        <el-menu-item index="/PMan">三十而立</el-menu-item>
      </el-sub-menu>
    </el-menu>
    <p>这里是测试内容-说明在Java页</p>
    </div>
    
</template>
  
<script lang="ts">
import { ref } from 'vue';

export default {
  setup() {
    const activeIndex = ref('1');

    const handleSelect = (key: string, keyPath: string[]) => {
      console.log(key, keyPath);
    };

    return {
      activeIndex,
      handleSelect
    };
  }
};
</script>
  
<style scoped>

.flex-grow {
    flex-grow: 1;
    position: fixed;
    top:0;
    left:0;
    z-index: 0;
}
</style>
```



```vue
<template>
<div>
  <Nav></Nav>
</div>
</template>
<script>
import Nav from '../components/Nav.vue'
export default{
  components:{
    Nav
  }
}
</script>
<style scoped>

</style>

```

## 5.在封装Nav后 内容与Nav重叠问题：

```css
<style scoped>
.container{
  position: fixed;
  margin-top:60px;
  left:0;
  top:0;
}
</style>
```

通过向上添加3%的margin来实现 确定导航栏像素之后 就向上加一个margin

## 6.el-container的属性设置

```vue
.el-aside{
  background-color: aqua;
}//正常.属性名就可以 当成一个类
```

# 7.走马灯的图片要在css中设置

```
.el-carousel__item:nth-child(2n) {
  background-image: url(./src/assets/images/banner1.png);

}
```

