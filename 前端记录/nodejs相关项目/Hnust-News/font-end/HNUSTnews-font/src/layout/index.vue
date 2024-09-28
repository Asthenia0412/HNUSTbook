<template>
<div>
    <div class="nav">
        <img class="logo" src="@/assets/kdwz.png" style="display: inline;" height="100%">
        <el-input v-model="input" placeholder="寻章摘句,仅是苦中作乐;落叶飞花,不过物竞天择。还请著文章！" style="width: 35%;margin-top: 40px;margin-left: 12%;"></el-input>
        <el-button round style="height: 70px;margin-top: 20px;margin-left: 15px;">请君赐教</el-button>
        <el-dropdown class="custom-dropdown">
    <span class="el-dropdown-link">
      我的信息<i class="el-icon-arrow-down el-icon--right"></i>
    </span>
    <el-dropdown-menu slot="dropdown">
      <el-dropdown-item>账户余额</el-dropdown-item>
      <el-dropdown-item>文集珍藏</el-dropdown-item>
      <el-dropdown-item>泼墨佳作</el-dropdown-item>
      <el-dropdown-item disabled>雅品铭鉴(修复中)</el-dropdown-item>
      <el-dropdown-item divided>退出账号</el-dropdown-item>
    </el-dropdown-menu>
  </el-dropdown>
        <el-image :src="HeadImg" style="margin-left: 1%;margin-bottom: 5px;"></el-image>

    </div>
<div class="main">
    <div class="margin-left"></div>
    <div class="left">
    <ul>
    <li><img src="@/assets/icons/layout/1-0.png" width="20%" height="20%"><router-link to="/personal-center">个人中心</router-link></li>
    <li><img src="@/assets/icons/layout/2-0.png" width="20%"><router-link to="/wonderful-articles">妙文荟萃</router-link></li>
    <li><img src="@/assets/icons/layout/3-0.png" width="20%"><router-link to="/Pointmall">积分商城</router-link></li>
    <li><img src="@/assets/icons/layout/4-0.png" width="20%"><router-link to="/ink-painting">泼墨雅席</router-link></li>
</ul>

    </div>
    <div class="gap"></div>
    <div class="medium">
        <slot name="medium"></slot>
    </div>
    <div class="gap"></div>
    <div class="right">
    <div class="rank">
    <ol>
        雅士共赏之妙文：
      <li v-for="article in articles" :key="article.id">
        {{ article.title }}
        <!-- 这里可以添加更多关于文章的信息，比如摘要或者链接 -->
      </li>
    </ol>
  </div>
    </div>

    <div class="margin-right"></div>
</div>
</div>
</template>
<script>
export default {
    name:'index',
  data() {
    return {
      articles: [
  { "id": 1, "title": "明月松间照", "content": "文章内容2" },
  { "id": 2, "title": "竹外桃花三两枝", "content": "文章内容2" },
  { "id": 3, "title": "秋水共长天一色", "content": "文章内容2" },
  { "id": 4, "title": "清泉石上流", "content": "文章内容2" },
  { "id": 5, "title": "疏影横斜水清浅", "content": "文章内容2" },
  { "id": 6, "title": "暗香浮动月黄昏", "content": "文章内容2" },
  { "id": 7, "title": "落霞与孤鹜齐飞", "content": "文章内容2" },
  { "id": 8, "title": "小荷才露尖尖角", "content": "文章内容2" },
  { "id": 9, "title": "春江水暖鸭先知", "content": "文章内容2" },
  { "id": 10, "title": "庭院深深深几许", "content": "文章内容2" }
],
input:'',
HeadImg: require('@/assets/headImg/default.jpg')


    };
  }
}

</script>
<style scoped>
.nav{
    display: flex;
}
.main{
    background-color: rgb(241,242,245);
    display: grid;
    grid-template-columns: 20% 10% 1% 35% 1% 15% 20%;
    
}
.logo{
    margin-left:10% ;
}
ul{
    
    display: flex;
    flex-direction: column;
}
li:hover{
    color: rgb(255,130,0)
}
li{
    margin-top: 10%;
}
a:hover{
    color: rgb(255,130,0)
}
a{
    text-decoration: none;
    font-size: 20px;
    
    font-family: 'KaiTi', sans-serif;
    color: #2b2e4a;

}
.rank{
    font-family: 'KaiTi', sans-serif;
    color: #2b2e4a;
    font-size: 20px;
}
.left{
    margin-top: 20px;
    height: 1000px;
    background-color: rgb(255,255,255);
}
.margin-left{
    height: 1000px;
    background-color: rgb(241,242,245);
}
.medium{
    margin-top: 20px;
    height: 1000px;
    background-color: rgb(255,255,255);
}
.right{
    margin-top: 20px;
    height: 1000px;
    background-color: rgb(255,255,255);

}
.margin-right{
    height: 1000px;
    background-color: rgb(241,242,245);
}
.gap{
    background-color: rgb(241,242,245);
}
.nav{
    height: 100px;
    background-color: white;
    
}
ol {
  counter-reset: list-counter;
  list-style: none;
}

ol li {
  counter-increment: list-counter;
  position: relative;
  padding-left: 20px; /* 确保有足够的空间显示数字 */
}

ol li::before {
  content: counter(list-counter) ".";
  position: absolute;
  left: 0;
  width: 20px; /* 数字占据的宽度 */
  height: 100%;
  display: inline-block;
  background: linear-gradient(to right, pink, orange);
  color: transparent;
  -webkit-background-clip: text;
  background-clip: text;
  font-weight: bold;
}
.custom-dropdown {
  margin-top: 50px;
  margin-left: 5%;
}
.el-dropdown-link {
    cursor: pointer;
    color: #409EFF;
  }
  .el-icon-arrow-down {
    font-size: 12px;
  }
</style>