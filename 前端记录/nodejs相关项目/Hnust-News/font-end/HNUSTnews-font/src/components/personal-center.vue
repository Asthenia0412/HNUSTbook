<template>
    <div>
      <index>
        <!-- 将新增内容放在名为medium的插槽中 -->
        <template v-slot:medium>
          <!-- 这里是你的新增内容 -->
          <div>
            <!-- 新增内容的HTML结构 -->
            <h1>这里是基于slot的个人中心内容-等待完工</h1>
            <!-- 可以添加更多的HTML元素或组件 -->
          </div>
        </template>
      </index>
    </div>
  </template>
<script>
import index from '@/layout/index.vue'
export default{
    name:'center',
    components:{
        index
    }
}
</script>
<style scoped>
.medium{
    background-color: yellow;
}
</style>