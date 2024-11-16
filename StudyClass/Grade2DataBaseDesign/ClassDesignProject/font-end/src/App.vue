<template>
  <div>


    <!-- 导航栏 -->
    <nav>
      <a href="#"> <router-link to="/Main" class="menu-link">
        系统主页
      </router-link></a>
      <a href="#"> <router-link to="/Blog" class="menu-link">
        员工博客
      </router-link></a>
      <a href="#"> <router-link to="/Register" class="menu-link">
        注册账号
      </router-link></a>
      <a href="#"><router-link to="/Login" class="menu-link">
        登录账号
      </router-link></a>
      <a href="#"><router-link to="/PersonOperation" class="menu-link">
        员工入口
      </router-link></a>
      <a href="#"><router-link to="/AdminOperation" class="menu-link">
        管理入口
      </router-link></a>
      <button class="logout-btn" @click="quit">退出系统</button>
    </nav>

    <!-- 全景图片展示区 -->
    <div class="hero">
      <h1 class="hero-font">欢迎来到员工管理系统</h1>
    </div>

    <!-- 内容部分 -->
    <div class="content">
      <router-view></router-view>
    </div>




  </div>

</template>


<script>
export default {
  name: 'Layout',
  methods:{
    quit(){
      localStorage.clear();
      alert("您已经退出了您的账号")
      this.$router.push('/Main')

    }
  }
};
</script>

<style scoped>
/* 基本重置 */
* {
  margin: 0;
  padding: 0;
  height: 100%;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif;
  background-color: #f4f4f4; /* 浅灰色背景 */
  color: #333; /* 字体颜色设置为深灰 */
}

/* 顶部导航栏样式 */
nav {
  display: flex;

  justify-content: space-between;
  align-items: center;
  background-color: #fff; /* 白色背景 */
  padding: 15px 15px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 导航栏阴影 */
  height: 50px;
}

nav a {
  color: #333;
  text-decoration: none;
  margin: 0 20px;
  font-size: 18px;
  font-weight: 600;
  transition: color 0.3s; /* 鼠标悬浮效果 */
}

nav a:hover {
  color: #0070c9; /* 鼠标悬停变为蓝色 */
}
nav .logout-btn {
  background-color: #fff;
  padding: 15px;
  border: 1px solid #0070c9;
  border-radius: 15px;
  font-weight: 600;
  cursor: pointer;
  transition: background-color 0.3s, transform 0.3s;
  color: #0070c9;

  display: flex;
  justify-content: center;  /* 水平居中 */
  align-items: center;      /* 垂直居中 */
}

nav .logout-btn:hover {
  background-color: #0070c9; /* 蓝色背景 */
  color: #fff; /* 白色文字 */
}


/* 全景图片展示区 */
.hero {
  display: flex;
  height: 300px;
  background-image: url('../src/assets/banner.jpg');
  background-size: cover;
  background-position: center;
  filter: brightness(80%); /* 使背景更暗，提升文字可读性 */
  align-items: center;
  justify-content: center;
}

.hero h1 {
  color: white;
  margin-top: 200px;
  text-align: center;
  justify-content: center;
  font-size: 40px;
  text-shadow: 1px 1px 10px rgba(0, 0, 0, 0.5);
}

/* 内容部分 */
.content {
  padding: 40px 20px;
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: center;
  height: 1000px;
  width: 100%;
}




/* 浅灰色渐变背景 */

</style>
