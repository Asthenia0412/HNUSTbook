<template>
  <div>
    <div class="wrapper">
      <div class="another1">
        <h2 class="title">员工信息</h2>
        <div class="info-item" v-for="(value, key) in userInfo" :key="key">
          <span class="label">{{ key }}：</span>
          <span>{{ formatValue(key, value) }}</span>
        </div>
      </div>
      <div class="another3">
        <div class="card function">
          <h3 class="title">修改密码</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="currentPassword">当前密码:</label>
              <input type="password" id="currentPassword" v-model="currentPassword" placeholder="请输入当前密码">
            </div>
            <div class="form-group">
              <label for="newPassword">新密码:</label>
              <input type="password" id="newPassword" v-model="newPassword" placeholder="请输入新密码">
            </div>
          </div>
          <button @click="changePassword">修改密码</button>
        </div>

        <!-- 查看部门信息 -->
        <div class="card function">
          <h3 class="title">查看部门信息</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="department">部门:</label>
              <select id="department" v-model="department">
                <option v-for="dept in departmentOptions" :value="dept">{{ dept }}</option>
              </select>
            </div>
          </div>
          <button @click="getDepartmentEmployees">查看部门员工</button>
        </div>

        <!-- 查看员工状态 -->
        <div class="card function">
          <h3 class="title">查看员工状态</h3>
          <div class="form-row">
            <div class="form-group">
              <label for="statusEmployeeId">员工ID:</label>
              <input type="text" id="statusEmployeeId" v-model="statusEmployeeId" placeholder="请输入员工ID">
            </div>
          </div>
          <button @click="getEmployeeStatus">查看员工状态</button>
        </div>





          <div class="container">
        <!-- 管理员信息 -->

            <!-- 修改密码 -->

            <!-- 弹窗 -->

            <div v-if="isModalOpen" class="modal-overlay" @click="closeModal">
              <div class="modal-content" @click.stop>
                <h3>员工列表</h3>
                <table>
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Sex</th>
                    <th>Birthday</th>
                    <th>Department</th>
                    <th>Job</th>
                    <th>Email</th>
                  </tr>
                  </thead>
                  <tbody>
                  <!-- 使用 v-for 渲染表格内容 -->
                  <tr v-for="user in users" :key="user.id">
                    <td>{{ user.id }}</td>
                    <td>{{ user.name }}</td>
                    <td>{{ user.sex }}</td>
                    <td>{{ user.birthday }}</td>
                    <td>{{ user.department }}</td>
                    <td>{{ user.job }}</td>
                    <td>{{ user.email }}</td>
                  </tr>
                  </tbody>
                </table>
                <!-- 关闭按钮 -->
                <button @click="closeModal">关闭</button>
              </div>
            </div>


            <div v-if="isModalOpen2" class="modal-overlay" @click="closeModal2">
              <div class="modal-content" @click.stop>
                <h3>员工列表</h3>
                <table>
                  <thead>
                  <tr>
                    <th>ID</th>
                    <th>Name</th>
                    <th>Sex</th>
                    <th>Birthday</th>
                    <th>Department</th>
                    <th>Job</th>
                    <th>Email</th>
                  </tr>
                  </thead>
                  <tbody>
                  <!-- 使用 v-for 渲染表格内容 -->
                  <tr>
                    <td>{{ user2.value.id }}</td>
                    <td>{{ user2.value.name }}</td>
                    <td>{{ user2.value.sex }}</td>
                    <td>{{ user2.value.birthday }}</td>
                    <td>{{ user2.value.department }}</td>
                    <td>{{ user2.value.job }}</td>
                    <td>{{ user2.value.email }}</td>
                  </tr>
                  </tbody>
                </table>
                <!-- 关闭按钮 -->
                <button @click="closeModal2">关闭</button>
              </div>
            </div>


          </div>

        </div>
      </div>

  </div>





</template>

<script setup>
import {ref, reactive} from 'vue';
import axios from 'axios';

const currentPassword = ref('');
const newPassword = ref('');
const department = ref('');
const statusEmployeeId = ref('');
const historyEmployeeId = ref('');
const loginName = ref('');
const loginPassword = ref('');
const departmentOptions = ref(['技术部', '后勤部', '人事部']); // 示例部门，根据实际情况调整
// 使用 ref 来创建响应式数据
const userInfo = ref({
  id: "正在加载中",
  name: "正在加载中",
  sex: "正在加载中",
  authority: "正在加载中",
  birthday: "正在加载中",
  department: "正在加载中",
  job: "正在加载中",
  eduLevel: "正在加载中",
  specialty: "正在加载中",
  address: "正在加载中",
  tel: "正在加载中",
  email: "正在加载中",
  state: "正在加载中",
  remark: "正在加载中",
});
// 获取并解析 localStorage 中的 'userInfo' 数据
const storedUserInfo = localStorage.getItem('userInfo');
if (storedUserInfo) {
  try {
    // 尝试解析 JSON 字符串
    const parsedUserInfo = JSON.parse(storedUserInfo);

    // 合并解析后的对象和原有的 userInfo
    userInfo.value = {
      ...userInfo.value, // 保持原有 userInfo 对象中的其他属性
      ...parsedUserInfo,  // 用存储的用户信息覆盖原有属性
    };
  } catch (error) {
    console.error("解析 localStorage 中的 userInfo 数据时出错", error);
  }
}

// 修改密码
const changePassword = () => {
  if (!currentPassword.value || !newPassword.value) {
    console.log('当前密码和新密码不能为空');
    return;
  }

  axios.put(`/User/employee/${userInfo.value.id}/${currentPassword.value}/${newPassword.value}`, {
    newPassword: newPassword.value
  })
      .then(response => {
        console.log('密码修改成功:', response.data);
        alert("用户"+userInfo.value.name+"密码修改成功")
        // 处理成功后的逻辑
      })
      .catch(error => {
        console.error('修改密码失败:', error);
        alert("用户"+userInfo.value.name+"密码修改失败!"+"请检查是否链接后端服务!"+"或请检查输入的旧的密码是否和数据库存储一致")
        // 处理错误信息
      });
};

// 查看部门信息
const getDepartmentEmployees = () => {
  if (!department.value) {
    console.log('部门不能为空');
    return;
  }
  axios.get(`/User/employee/department`, {
    params: {department: department.value}
  })
      .then(response => {
        console.log('部门员工信息:', response.data);
        // 处理成功后的逻辑，例如显示员工列表
        users.value = response.data;
        openModal();
      })
      .catch(error => {
        console.error('获取部门员工信息失败:', error);
        // 处理错误信息
      });
};

// 查看员工状态
const getEmployeeStatus = () => {
  if (!statusEmployeeId.value) {
    console.log('员工ID不能为空');
    return;
  }

  axios.get(`/User/employee/status/${statusEmployeeId.value}`)
      .then(response => {
        console.log('员工状态:', response.data);
        alert("员工状态为"+(response.data === 'T'?'员工已经启用':'员工正在待岗中'));

        // 处理成功后的逻辑，例如显示员工状态
      })
      .catch(error => {
        console.error('获取员工状态失败:', error);
        // 处理错误信息
      });
};



// 定义响应式数据
const employeeId = ref(null);
const jobOptions = ref(['初级职称', '中级职称', '高级职称']);
const employeeData = reactive({
  id: 2,
  name: '张三',
  sex: 'M',
  authority: 'admin',
  birthday: '1990-05-15',
  department: '技术部',
  job: '初级职称',
  eduLevel: '本科',
  specialty: '计算机科学',
  address: '北京市朝阳区XXX街道',
  tel: '13812345678',
  email: 'zhangsan@example.com',
  state: 'T',
  remark: '暂无备注',
});
const id = ref();
const state = ref('T');
const users = ref([]);
const user2 = reactive({});
const isModalOpen = ref(false);
const isModalOpen2 = ref(false);
const openModal = () => {
  isModalOpen.value = true;
}
const closeModal = () => {
  isModalOpen.value = false;
}
const openModal2 = () => {
  isModalOpen2.value = true;
}
const closeModal2 = () => {
  isModalOpen2.value = false;
}

// 格式化显示值
const formatValue = (key, value) => {
  if (key === 'sex') return value === 'M' ? '男' : '女';
  if (key === 'state') return value === 'T' ? '在职' : '离职';
  return value;
};

// 获取选项
const getOptions = (key) => {
  const options = {
    sex: ['M', 'F'],
    department: ['技术部', '后勤部', '行政部'], // 示例部门，根据实际情况调整
    state: ['T', 'F'], // 示例状态，根据实际情况调整
    eduLevel: ['小学', '初中', '高中', '职高', '大专', '大本', '硕士', '博士', '博士后'],
  };
  return options[key] || [];
};



</script>
<style scoped>
.another3{
  display: flex;
  grid-column: 3;
  grid-row: 1;
}
.wrapper {
  display: flex;
}

/* 主要容器 */
/* 主要容器 */
.container {
  display: flex;
  flex-direction: column;
  align-items: stretch;
  padding: 30px;
  background-color: #f9f9f9;
}

/* 行容器 */
.row {
  display: flex;
  justify-content: space-between;
  gap: 20px;
  margin-bottom: 20px;
}

/* 卡片样式 */
.card {
  background-color: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
  width: 100%;
  max-width: 500px;
  padding: 20px;
  transition: transform 0.2s ease, box-shadow 0.2s ease;
}

.card:hover {
  transform: translateY(-5px);
  box-shadow: 0 8px 16px rgba(0, 0, 0, 0.2);
}

/* 卡片标题 */
.title, .card h3 {
  text-align: center;
  font-size: 20px;
  margin-bottom: 15px;
  color: #333;
}

/* 信息项 */
.info-item {
  margin-bottom: 12px;
}

.label {
  font-weight: 600;
  color: #444;
}

span {
  color: #666;
}

/* 表单控件 */
.form-row {
  display: flex;
  flex-wrap: wrap;
  gap: 20px;
}

.form-group {
  flex: 1 1 45%;
  margin-bottom: 15px;
}

.form-group label {
  display: block;
  margin-bottom: 8px;
  color: #555;
}

.form-group input,
.form-group select {
  width: 100%;
  padding: 10px;
  margin-top: 5px;
  border: 1px solid #ddd;
  border-radius: 5px;
  font-size: 14px;
  box-sizing: border-box;
}

/* 按钮样式 */
button {
  width: 100%;
  padding: 12px;
  background-color: #007BFF;
  color: white;
  border: none;
  border-radius: 4px;
  font-size: 16px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

button:hover {
  background-color: #0056b3;
}

/* 响应式布局 */
@media (max-width: 768px) {
  .container {
    flex-direction: column;
    align-items: stretch;
  }

  .card {
    max-width: 100%;
  }

  .form-group {
    flex: 1 1 100%;
  }
}

/* 弹窗的背景遮罩 */
.modal-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: rgba(0, 0, 0, 0.5);
  display: flex;
  justify-content: center;
  align-items: center;
  z-index: 999;
}

/* 弹窗内容 */
.modal-content {
  background-color: white;
  padding: 20px;
  border-radius: 10px;
  width: 80%;
  max-width: 800px;
  overflow-y: auto;
}

/* 表格样式 */
table {
  width: 100%;
  border-collapse: collapse;
  margin-top: 20px;
}

table th, table td {
  border: 1px solid #ddd;
  padding: 8px;
  text-align: left;
}

table th {
  background-color: #f4f4f4;
}

/* 关闭按钮样式 */
button {
  margin-top: 20px;
  padding: 10px;
  background-color: #007BFF;
  color: white;
  border: none;
  border-radius: 5px;
  cursor: pointer;
}

button:hover {
  background-color: #0056b3;
}
</style>