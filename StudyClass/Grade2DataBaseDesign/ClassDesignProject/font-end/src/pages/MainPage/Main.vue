<script>
console.log("页面可以被加载")
export default {

}
</script>

<template>
  <div class="content">


    <!-- 卡片区 -->
    <div class="card-wrap">
      <div class="card gradient-bg">
        <div class="card-title">逻辑减重</div>
      </div>
      <div class="card gradient-bg">
        <div class="card-title">UI焕新</div>
      </div>
      <div class="card gradient-bg">
        <div class="card-title">结构优化</div>
      </div>
      <div class="card gradient-bg">
        <div class="card-title">赋能效率</div>
      </div>
    </div>
    <div class="announcement">
      <strong>最新公告:</strong>
      <p>23计科六班-肖永财-2314020106</p>
      <p>技术栈：</p>
      <p>前端：Vue3+Vite</p>
      <p>后端：SpringBoot/Mybatis-plus/MySQL</p>

    </div>
  </div>
</template>

<style scoped>
/* 基本重置 */
* {
  margin: 0;
  padding: 0;
  box-sizing: border-box;
}

body {
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", "Roboto", "Oxygen", "Ubuntu", "Cantarell", "Fira Sans", "Droid Sans", "Helvetica Neue", sans-serif;
  background-color: #f4f4f4; /* 浅灰色背景 */
  color: #333; /* 字体颜色设置为深灰 */
}
.card-wrap{
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
  justify-content: center;
  height: 100px;
}
/* 内容部分 */


/* 公告区 */
.announcement {
  width: 100%;
  background-color: #f4f4f4; /* 浅灰色背景 */
  color: #333; /* 字体颜色设置为深灰 */
  padding: 20px;
  margin-bottom: 200px;
  text-align: center;
  border-radius: 10px;
  font-size: 18px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 增强阴影效果 */
}

/* 卡片样式 */
.gradient-bg {
  background: linear-gradient(135deg, #f4f4f4, #e6e6e6);
}
.card {
  background: white;
  width: 250px;
  height: 200px;
  border-radius: 15px;
  box-shadow: 0 1px 3px rgba(0, 0, 0, 0.1); /* 增强阴影效果 */
  overflow: hidden;
  transition: transform 0.3s, box-shadow 0.3s;
  display: flex;
  justify-content: center;
  align-items: center;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2); /* 悬浮时更强的阴影效果 */
}

.card-title {
  font-size: 18px;
  font-weight: 600;
  color: #333;
}

/* 页脚样式 */
footer {
  background-color: #333;
  color: white;
  padding: 20px 0;
  text-align: center;
  font-size: 14px;
}

footer a {
  color: #0070c9;
  text-decoration: none;
  transition: color 0.3s;
}

footer a:hover {
  color: #0056b3; /* 页脚链接的悬浮效果 */
}

/* 浅灰色渐变背景 */
.gradient-bg {
  background: linear-gradient(135deg, #f4f4f4, #e6e6e6);
}

</style>