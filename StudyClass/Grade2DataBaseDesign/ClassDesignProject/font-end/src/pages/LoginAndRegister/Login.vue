<template>
  <div class="login-form">
    <form @submit.prevent="login">
      <!-- 姓名 -->
      <div class="form-group">
        <label for="name">姓名</label>
        <input type="text" id="name" v-model="loginData.name" placeholder="请输入姓名" required />
      </div>

      <!-- 密码 -->
      <div class="form-group">
        <label for="passwd">密码</label>
        <input
            type="password"
            id="passwd"
            v-model="loginData.passwd"
            placeholder="请输入密码"
            required
        />
      </div>

      <!-- 提交按钮 -->
      <button type="submit">登录</button>
    </form>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      loginData: {
        name: '',
        passwd: '',
      },
    };
  },
  methods: {
    async login() {
      try {
        const response = await axios.post('/User/employee/login', {
          NAME: this.loginData.name,
          PASSWD: this.loginData.passwd,
        });
        console.log('登录成功', response.data);
        // 将返回值存在localStorage中
        // 假设你已经从 API 获取到 response.data
        Object.keys(response.data).forEach(key => {
          // 将对象转换为字符串，并将双引号替换为单引号
          const dataWithSingleQuotes = JSON.stringify(response.data[key])
              .replace(/"/g, "'");

          localStorage.setItem('userInfo', JSON.stringify(response.data));
          // 将替换后的数据存储到 localStorage
          localStorage.setItem(key, dataWithSingleQuotes);
        });

// 设置登录标志
        localStorage.setItem('isLoggedIn', 'true');

// 如果有其他需要存储的内容，例如 authority
        const authorityWithSingleQuotes = JSON.stringify(response.data.authority)
            .replace(/"/g, "");

        localStorage.setItem('authority', authorityWithSingleQuotes);
        alert("恭喜您登录成功")
        // 设置用户角色
        if(localStorage.getItem('authority')==='admin'){
          this.$router.push('/AdminOperation'); // 假设登录后跳转到仪表盘页面
        }else{
          this.$router.push('/PersonOperation')
        }
      } catch (error) {
        console.error('登录失败', error);
      }
    },
  },
};
</script>

<style scoped>
/* 基本的页面布局和字体样式 */
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column; /* 垂直布局 */
  justify-content: flex-start; /* 从顶部开始对齐 */
  align-items: center;
  min-height: 100vh;
  background-image: url("background.jpg");
  background-size: cover; /* 背景图片覆盖整个页面 */
}

/* 登录表单样式 */
.login-form {
  width: 100%; /* 表单宽度为100%，横向铺满屏幕 */
  max-width: 600px; /* 可以设置一个最大宽度，使表单不会过宽 */
  padding: 20px; /* 给表单内添加一些内边距 */
  box-sizing: border-box; /* 确保内边距和边框不影响宽度 */
  margin-top: 0; /* 去掉上外边距，表单紧贴页面顶部 */
  border-radius: 10px; /* 圆角边框 */
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1); /* 轻微阴影 */
  background-color: rgba(255, 255, 255, 0.8); /* 背景颜色，略带透明 */
}

/* 控制每一项表单元素之间的间距 */
.form-group {
  margin-bottom: 20px; /* 增加底部间距 */
  margin-top: 0;
}

/* 设置输入框的统一样式 */
input {
  width: 100%;
  padding: 12px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box; /* 确保padding不会影响宽度 */
  font-size: 16px; /* 增大字体尺寸 */
}

/* 按钮样式 */
button {
  width: 100%; /* 按钮与输入框宽度对齐 */
  padding: 12px;
  background-color: #4CAF50; /* 绿色背景 */
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px; /* 增大字体尺寸 */
  transition: background-color 0.3s ease; /* 添加平滑过渡效果 */
}

/* 按钮的悬浮样式 */
button:hover {
  background-color: #45a049; /* 悬浮时变暗 */
}

/* 增加聚焦状态的输入框样式 */
input:focus {
  border-color: #4CAF50; /* 聚焦时边框变绿 */
  outline: none; /* 去掉默认的聚焦轮廓 */
}

/* 为表单标签（如果有的话）添加样式 */
label {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
  display: block; /* 确保标签占一行 */
}

/* 页面上的网格布局 */
.grid-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr); /* 3列等宽 */
  gap: 20px; /* 每个项之间的间距 */
  padding: 20px;
  max-width: 1000px; /* 最大宽度，避免过宽 */
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.grid-item {
  background-color: #fff;
  border-radius: 10px;
  padding: 15px;
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.grid-item:hover {
  transform: translateY(-5px); /* 鼠标悬停时轻微上移 */
  box-shadow: 0 6px 15px rgba(0, 0, 0, 0.15);
}

.avatar {
  width: 80px;
  height: 80px;
  border-radius: 50%;
  margin-bottom: 10px;
  object-fit: cover;
}

.username {
  font-size: 1.2em;
  font-weight: bold;
  color: #333;
  margin-bottom: 10px;
}

.bio {
  font-size: 1em;
  color: #666;
  margin-top: 10px;
}

/* 响应式：移动端优化 */
@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: repeat(2, 1fr); /* 小屏幕设备时 2列布局 */
  }
}

@media (max-width: 480px) {
  .grid-container {
    grid-template-columns: 1fr; /* 更小屏幕时，单列布局 */
  }

  .login-form {
    max-width: 90%; /* 移动端时，表单宽度占屏幕90% */
  }
}

</style>
