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
/* 全局样式修正 */
body {
  font-family: 'San Francisco', 'Arial', sans-serif; /* 使用Apple的字体 */
  margin: 0;
  padding: 0;
  display: flex;
  flex-direction: column;
  justify-content: center; /* 中心对齐 */
  align-items: center;
  min-height: 100vh;
  background-color: #f2f2f2; /* 使用灰色背景 */
  color: #333; /* 文字颜色为深灰色 */
}

/* 登录表单样式修正 */
.login-form {
  width: 100%;
  max-width: 600px;
  padding: 40px; /* 增加内边距 */
  box-sizing: border-box;
  margin-top: 0;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  background-color: #fff; /* 使用白色背景 */
}

/* 卡片布局样式 */
.card {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
  border-radius: 10px;
  background-color: #fff;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.card:hover {
  transform: translateY(-10px); /* 浮动效果加强 */
  box-shadow: 0 6px 12px rgba(0, 0, 0, 0.2);
}

/* 表单元素样式 */
.form-group {
  width: 100%;
  margin-bottom: 20px;
}

input {
  width: 100%;
  padding: 12px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 4px;
  box-sizing: border-box;
  font-size: 16px;
}

button {
  width: 100%;
  padding: 12px;
  background-color: #000; /* 使用黑色 */
  color: #fff;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 16px;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #333; /* 悬浮时变暗 */
}

input:focus {
  border-color: #000; /* 聚焦时边框变黑 */
  outline: none;
}

label {
  font-size: 14px;
  color: #333;
  margin-bottom: 5px;
  display: block;
}

/* 网格布局样式 */
.grid-container {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: 20px;
  padding: 20px;
  max-width: 1000px;
  background-color: #fff;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.grid-item {
  display: flex;
  flex-direction: column;
  align-items: center;
  background-color: #fff;
  border-radius: 10px;
  padding: 15px;
  text-align: center;
  box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.grid-item:hover {
  transform: translateY(-5px);
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

/* 响应式样式 */
@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: repeat(2, 1fr);
  }
}

@media (max-width: 480px) {
  .grid-container {
    grid-template-columns: 1fr;
  }

  .login-form {
    max-width: 90%;
  }
}

</style>
