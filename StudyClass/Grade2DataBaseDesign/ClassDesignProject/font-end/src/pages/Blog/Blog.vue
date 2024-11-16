<template>
  <div class="forum-container">
    <div class="left-panel" :style="{ width: '70%' }">
      <div class="post-form">
        <input v-model="newPost.title" type="text" placeholder="标题" />
        <input v-model="newPost.author" type="text" placeholder="作者" />
        <input v-model="newPost.category" type="text" placeholder="分类（可选）" />
        <textarea v-model="newPost.content" placeholder="内容"></textarea>
        <button @click="submitPost">发送</button>
      </div>
      <div class="posts">
        <div
            v-for="post in posts"
            :key="post.id"
            class="post-card"
            @mouseover="hoverCard(post.id)"
            @mouseleave="leaveCard(post.id)"
            @click="openPost(post)"
        >
          <h3>{{ post.title }}</h3>
          <p>{{ post.contentPreview }}</p>
          <div class="cardFlex">
            <div class="post-info">
              <span>{{ post.author }}</span>
              <span>{{ post.date }}</span>
            </div>
          </div>
          <div v-if="modalOn" v-html="post.contentPreview"></div>
        </div>
      </div>
    </div>
    <div class="right-panel" :style="{ width: '30%' }">
      <!-- 公告栏 -->
      <div class="announcement-panel">
        <div v-for="(item, index) in announcements" :key="index" class="announcement-card">
          <h3>{{ item.title }}</h3>
          <p>{{ item.content }}</p>
        </div>
      </div>
    </div>
    <div v-if="selectedPost" class="modal">
      <div class="modal-content">
        <span class="close" @click="selectedPost = null">&times;</span>
        <h2>{{ selectedPost.title }}</h2>
        <p>发布时间: {{ selectedPost.date }}</p>
        <p>作者: {{ selectedPost.author }}</p>
        <p>{{this.selectedPost.content}}</p> <!-- 使用v-html来显示HTML内容 -->
      </div>
    </div>
  </div>
</template>

<script>
import axios from 'axios';

export default {
  data() {
    return {
      newPost: {
        title: '',
        content: '',
        author: '',
        category: '',
        isPublished: false, // 默认设置为未发布
      },
      modalOn:false,
      posts: [],
      selectedPost: null,
      announcements: [
        { title: '欢迎来到员工论坛', content: '尊敬的员工:'+(localStorage.getItem('name')!=null?localStorage.getItem('name'):'【您还没有登录呢】')+'欢迎您的到来！'+"\n"},
        { title: '新功能上线', content: '我们上线了新的搜索功能，可以更方便地查找信息。' },
        { title: '假期安排', content: '公司将在2024年12月1日至2024年12月7日进行寒假休假安排。' },
        { title: '博客查询', content: '有没有一种可能呢？你点击左侧的小元素就可以查看一篇博文的具体内容呢！' },
      ],
    };
  },
  created() {
    this.fetchPosts();
  },
  methods: {
    submitPost() {
      const post = {
        title: this.newPost.title,
        content: this.newPost.content,
        author: this.newPost.author,
        category: this.newPost.category,
        isPublished: this.newPost.isPublished
      };

      axios.post('/Discuss/newPress', post, {
        headers: {
          'Content-Type': 'application/json'
        }
      })
          .then(response => {
            const data = response.data;
            if (data.success) {
              this.posts.unshift({
                id: data.id,
                title: data.title,
                contentPreview: data.contentPreview,
                content: data.content,
                author: data.author,
                date: data.creationTime
              });

              // 重置表单字段
              this.newPost.title = '';
              this.newPost.content = '';
              this.newPost.author = '';
              this.newPost.category = '';
            } else {
              alert(data.message); // 显示错误信息
            }
          })
          .catch(error => {
            console.error('Error:', error);
          });
    },


    // 获取所有帖子
    fetchPosts() {
      axios.get('/Discuss/GetAll')
          .then(response => {
            // 确认响应数据的结构，并提取博客列表
            const blogs = response.data || response.data.data || [];
            this.posts = blogs.map(post => ({
              id: post.id,
              title: post.title,
              contentPreview: post.contentPreview,
              content: post.content,
              author: post.author,
              date: post.creationTime
            }));
          })
          .catch(error => {
            console.error('Error:', error);
            // 如果后端没有内容，则创建占位卡片
            this.posts = Array.from({ length: 9 }, (_, i) => ({
              id: i,
              title: 'Blog加载失败qaq' + (i + 1),
              contentPreview: '你猜猜是为什么呢？还不是因为你没有启动后端服务！！！这里的信息都是实时从后端拉取的哦！！！',
              author: '丰川祥子',
              date: new Date().toISOString()
            }));
          });
    }
    ,

    hoverCard(id) {
      const card = this.$el.querySelector(`.post-card[key="${id}"]`);
      if (card) card.classList.add('hover');
    },
    leaveCard(id) {
      const card = this.$el.querySelector(`.post-card[key="${id}"]`);
      if (card) card.classList.remove('hover');
      this.modalOn=false;
    },
    openPost(post) {
      // 保存完整的帖子内容到selectedPost
      this.selectedPost = {
        ...post,
      };
      console.log(this.selectedPost); // 检查selectedPost的内容
      this.modalOn = true;
    }}}



</script>

<style scoped>
.post-form {
  background-color: #f0f0f0;
  padding: 20px;
  border-radius: 8px;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  margin-bottom: 30px;
}

.post-form input,
.post-form textarea {
  width: 100%;
  margin-bottom: 15px;
  padding: 10px;
  border: 1px solid #d9d9d9;
  border-radius: 4px;
  box-sizing: border-box;
}

.post-form textarea {
  height: 100px;
  resize: vertical;
}

.post-form button {
  background-color: #333;
  color: #fff;
  border: none;
  padding: 10px 20px;
  border-radius: 4px;
  cursor: pointer;
  transition: background-color 0.3s ease;
}

.post-form button:hover {
  background-color: #555;
}
.posts{
  display: grid;              /* 启用网格布局 */
  grid-template-columns: repeat(3, 1fr); /* 设置3列，每列宽度相等 */
  grid-template-rows: repeat(3, 1fr);    /* 设置3行，每行高度相等 */
  gap: 10px;                  /* 设置网格项之间的间距 */
}
/* 卡片样式 */
.post-card {
  background-color: #fff;
  border: 1px solid #e1e1e1;
  border-radius: 8px;
  padding: 20px;
  margin-bottom: 20px;
  transition: transform 0.3s ease, box-shadow 0.3s ease;
  cursor: pointer;
  box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}
.forum-container {
  display: flex;
  height: 100vh;
}

.right-panel {
  display: flex;
  flex-direction: column;
  align-items: center;
  padding: 20px;
}

.announcement-panel {
  width: 100%;
  margin-top: 20px;
}

.announcement-card {
  background-color: #ffffff;
  border-radius: 8px;
  padding: 20px;
  margin: 10px 0;
  box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  transition: transform 0.3s ease, box-shadow 0.3s ease;
}

.announcement-card:hover {
  transform: translateY(-10px); /* 鼠标悬浮时浮动效果 */
  box-shadow: 0 10px 20px rgba(0, 0, 0, 0.2); /* 增强阴影 */
}

.announcement-card h3 {
  margin: 0;
  font-size: 18px;
  font-weight: bold;
}

.announcement-card p {
  margin-top: 10px;
  font-size: 14px;
  color: #555;
}

.post-form {
  margin-bottom: 20px;
}

.post-card {
  border: 1px solid #ccc;
  padding: 10px;
  margin-bottom: 10px;
  transition: transform 0.3s ease;
  cursor: pointer;

}

.post-card.hover {
  transform: translateY(-5px);
}

.post-info {
  display: flex;
  justify-content: space-between;
}

.modal {
  display: flex;
  position: fixed;
  z-index: 1;
  left: 0;
  top: 0;
  width: 100%;
  height: 100%;
  overflow: auto;
  background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
  background-color: #fefefe;
  margin: 15% auto;
  padding: 20px;
  border: 1px solid #888;
  width: 80%;
}

.close {
  color: #aaa;
  float: right;
  font-size: 28px;
  font-weight: bold;
}

.close:hover,
.close:focus {
  color: black;
  text-decoration: none;
  cursor: pointer;
}

/* 黑白灰色调 */
* {
  color: #333;
  background-color: #fff;
}

.post-card {
  background-color: #f9f9f9;
}

button {
  background-color: #333;
  color: #fff;
  border: none;
  padding: 10px 20px;
  cursor: pointer;
}

button:hover {
  background-color: #555;
}
</style>
