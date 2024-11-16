<template>
  <div class="wrapper">
    <div class="employee-form">
      <!-- 表单开始 -->
      <form @submit.prevent="submitForm">
        <!-- 姓名 -->
        <div class="form-group">
          <label for="name">姓名</label>
          <input type="text" id="name" v-model="formData.name" placeholder="请输入姓名" required />
        </div>

        <!-- 密码 -->
        <div class="form-group">
          <label for="passwd">密码</label>
          <input
              type="password"
              id="passwd"
              v-model="formData.passwd"
              placeholder="请输入密码"
              required
              :title="passwordTooltip"
          />
          <small>密码至少6个字符，包含字母和数字</small>
        </div>

        <!-- 用户权限 -->
        <div class="form-group">
          <label for="authority">用户权限</label>
          <select id="authority" v-model="formData.authority" required>
            <option value="admin">管理员</option>
            <option value="user">普通用户</option>
            <option value="manager">经理</option>
          </select>
        </div>

        <!-- 性别 -->
        <div class="form-group">
          <label for="sex">性别</label>
          <select id="sex" v-model="formData.sex" required>
            <option value="M">男</option>
            <option value="F">女</option>
          </select>
        </div>

        <!-- 生日 -->
        <div class="form-group">
          <label for="birthday">生日 (YYYY-MM-DD)</label>
          <input
              type="date"
              id="birthday"
              v-model="formData.birthday"
              required
          />
        </div>

        <!-- 部门 -->
        <label for="department">部门</label>
        <select id="department" v-model="formData.department">
          <option v-for="dept in departments" :key="dept" :value="dept">{{ dept }}</option>
        </select>

        <!-- 职务 -->
        <label for="position">职务</label>
        <select id="position" v-model="formData.job">
          <option v-for="pos in positions" :key="pos" :value="pos">{{ pos }}</option>
        </select>

        <!-- 受教育程度 -->
        <label for="education">受教育程度</label>
        <select id="education" v-model="formData.eduLevel">
          <option v-for="edu in educationLevels" :key="edu" :value="edu">{{ edu }}</option>
        </select>

        <!-- 专业技能 -->
        <div class="form-group">
          <label for="specialty">专业技能</label>
          <input
              type="text"
              id="specialty"
              v-model="formData.specialty"
              placeholder="请输入专业技能"
              required
          />
        </div>

        <!-- 家庭住址 -->
        <div class="form-group">

          <label for="address">家庭住址</label><input
            type="text"
            id="address"
            v-model="formData.address"
            placeholder="请输入家庭住址"
            required
        />
        </div>

        <!-- 联系电话 -->
        <div class="form-group">
          <label for="tel">联系电话</label>
          <input
              type="tel"
              id="tel"
              v-model="formData.tel"
              placeholder="请输入联系电话"
              required
              pattern="^\d{3}-\d{4}-\d{4}$"
          />
          <small>格式: 123-4567-8901</small>
        </div>

        <!-- 电子邮箱 -->
        <div class="form-group">
          <label for="email">电子邮箱</label>
          <input
              type="email"
              id="email"
              v-model="formData.email"
              placeholder="请输入电子邮箱"
              required
          />
        </div>

        <!-- 当前状态 -->
        <div class="form-group">
          <label for="state">当前状态</label>
          <select id="state" v-model="formData.state" required>
            <option value="T">员工</option>
            <option value="F">非员工</option>
          </select>
        </div>

        <!-- 备注 -->
        <div class="form-group">
          <label for="remark">备注</label>
          <textarea
              id="remark"
              v-model="formData.remark"
              placeholder="请输入备注（可选）"
          ></textarea>
        </div>

        <!-- 提交按钮 -->
        <button type="submit">提交</button>
      </form>
    </div>
    <div class="Claims">
      <div class="grid-container">
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/2" alt="头像1" class="avatar">
          <div class="username">Asthenia</div>
          <div class="bio">今天过得不错，和朋友们一起去看了电影。</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/3" alt="头像2" class="avatar">
          <div class="username">CharlesT</div>
          <div class="bio">今天在家休息，做了一些家务事，感觉很充实。</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/4" alt="头像3" class="avatar">
          <div class="username">Tim</div>
          <div class="bio">午饭吃了自己做的炒饭，味道不错，哈哈！</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/1" alt="头像4" class="avatar">
          <div class="username">Cuda</div>
          <div class="bio">最近工作有点忙，准备找个时间去旅行放松一下。</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/5" alt="头像5" class="avatar">
          <div class="username">Peter</div>
          <div class="bio">读了两本新书，感觉受益匪浅，真想多读书！</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/6" alt="头像6" class="avatar">
          <div class="username">Jims</div>
          <div class="bio">最近开始做运动，保持健康！</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/7" alt="头像7" class="avatar">
          <div class="username">Holly</div>
          <div class="bio">终于完成了一个重要项目，现在可以好好休息一下了。</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/8" alt="头像8" class="avatar">
          <div class="username">Horoscropex</div>
          <div class="bio">学习编程的过程中，遇到了一些挑战，但也收获了不少经验。</div>
        </div>
        <div class="grid-item">
          <img src="https://www.dmoe.cc/random.php/9" alt="头像9" class="avatar">
          <div class="username">Metaphysics</div>
          <div class="bio">好吧，数据库课设写起来真累啊！</div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      formData: {
        id: Math.random()*(100000,1)+10000,
        name: '',
        passwd: '',
        authority: 'user',
        sex: 'M',
        birthday: '',
        department: '',
        job: '',
        eduLevel: '',
        specialty: '',
        address: '',
        tel: '',
        email: '',
        state: 'T',
        remark: '',
      },
      // 部门选项
      departments: ['技术部', '后勤部', '行政部'],
      // 受教育程度选项
      educationLevels: ['小学','初中', '高中', '职高','大专', '大本', '硕士', '博士', '博士后'],
      positions: ['初级职称', '中级职称', '高级职称'],
      passwordTooltip: "密码至少6个字符，包含字母和数字",
    };
  },
  methods: {
    async submitForm() {
      // 提交数据到后端
      try {
        const response = await axios.post('/Admin/employee/add', this.formData);
        console.log('员工创建成功', response.data);
        alert("恭喜您,注册成功,是时候登录试试咯！")
        this.resetForm(); // 提交成功后清空表单
      } catch (error) {
        console.error('提交失败', error);
        alert("您的提交信息有误,请检查后再尝试注册/也许此时后端服务无法运行")
      }
    },
    // 重置表单
    resetForm() {
      this.formData = {
        name: '',
        passwd: '',
        authority: 'user',
        sex: 'M',
        birthday: '',
        department: '',
        job: '',
        eduLevel: '',
        specialty: '',
        address: '',
        tel: '',
        email: '',
        state: 'T',
        remark: '',
      };
    },
  },
};
</script>

<style scoped>

  /* 基本的页面布局和字体样式 */
body.Claims{
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
  background-color: #f7f7f7;
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

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

/* 调整屏幕尺寸 */
@media (max-width: 768px) {
  .grid-container {
    grid-template-columns: repeat(2, 1fr); /* 小屏幕设备时 2列布局 */
  }
}

@media (max-width: 480px) {
  .grid-container {
    grid-template-columns: 1fr; /* 更小屏幕时，单列布局 */
  }
}








.wrapper{
  display: flex;
}
/* 样式部分 */
body {
  font-family: Arial, sans-serif;
  margin: 0;
  padding: 0;
background-image: url("background.jpg");
  display: flex;
  justify-content: center;
  align-items: center;
  min-height: 100vh;
}

.employee-form {
  display: grid;
  grid-template-columns: 1fr; /* 单列布局 */
  gap: 20px;
  padding: 20px;
  max-width: 600px;
  background-color: white;
  border-radius: 10px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
}

.form-group {
  display: flex;
  flex-direction: column;
}

label {
  font-size: 1em;
  color: #333;
  margin-bottom: 5px;
}

input, select, textarea {
  padding: 10px;
  margin-top: 5px;
  border: 1px solid #ccc;
  border-radius: 4px;
  font-size: 1em;
  box-sizing: border-box;
}

button {
  padding: 12px 20px;
  background-color: #4CAF50;
  color: white;
  border: none;
  border-radius: 4px;
  cursor: pointer;
  font-size: 1.1em;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #45a049;
}

small {
  display: block;
  font-size: 0.85em;
  color: #888;
}

/* 调整屏幕尺寸 */
@media (max-width: 768px) {
  .employee-form {
    padding: 15px;
  }
}
</style>
