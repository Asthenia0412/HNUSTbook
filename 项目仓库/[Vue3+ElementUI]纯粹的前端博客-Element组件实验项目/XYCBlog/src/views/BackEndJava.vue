<template>
<div class="normal">
  <link href="https://fonts.googleapis.com/css?family=Kai+Ti&display=swap" rel="stylesheet">

  <Nav></Nav>
  <div class="container">
  <div class="common-layout">
    <el-container>
      <el-aside width="300px">
        <div class="poem">
          <br>
          <p>春江潮水连海平，海上明月共潮生。</p>
<p>滟滟随波千万里，何处春江无月明！</p>
<p>江流宛转绕芳甸，月照花林皆似霰。</p>
<p>空里流霜不觉飞，汀上白沙看不见。</p>
<p>江天一色无纤尘，皎皎空中孤月轮。</p>
<p>江畔何人初见月？江月何年初照人？</p>
<p>人生代代无穷已，江月年年望相似。</p>
<p>不知江月待何人，但见长江送流水。</p>
<p>白云一片去悠悠，青枫浦上不胜愁。</p>
<p>谁家今夜扁舟子？何处相思明月楼？</p>
<p>可怜楼上月裴回，应照离人妆镜台。</p>
<p>玉户帘中卷不去，捣衣砧上拂还来。</p>
<p>此时相望不相闻，愿逐月华流照君。</p>
<p>鸿雁长飞光不度，鱼龙潜跃水成文。</p>
<p>昨夜闲潭梦落花，可怜春半不还家。</p>
<p>江水流春去欲尽，江潭落月复西斜。</p>
<p>斜月沉沉藏海雾，碣石潇湘无限路。</p>
<p>不知乘月几人归，落月摇情满江树。</p>
        </div>

      </el-aside>
      <el-main>
        <el-carousel  type="card" style="width: 1600px; margin: 0 auto;">
    <el-carousel-item v-for="item in 4" :key="item">
      <img/>
    </el-carousel-item>
  </el-carousel>
  <div class="normal">
    <el-collapse accordion>
      <el-collapse-item name="1">
        <template #title>
          <p> &nbsp &nbsp Java11版本前瞻</p><el-icon class="header-icon">
            <info-filled />
          </el-icon>
        </template>
        <div>
          1. 启动单文件源代码程序：JDK 11允许使用Java虚拟机（JVM）直接执行单个Java源代码文件，无需先进行编译。<br>
2. 增强的HTTP客户端：JDK 11引入了一个新的HTTP客户端API，它是基于Java 9中引入的HTTP客户端API的升级版，提供了更好的性能和易用性。<br>
3. 垃圾收集器（ZGC）：JDK 11引入了ZGC（Z Garbage Collector），这是一个可扩展的低延迟垃圾收集器，适用于多核心处理器和大型内存系统。<br>
4. Lambda表达式和变量句柄的局部变量语法：在JDK 11中，可以使用var关键字来声明局部变量，包括Lambda表达式的参数。<br>
5. 支持Unicode 10：JDK 11更新了对Unicode的支持，包括Unicode 10标准。<br>
6. ChaCha20和Poly1305加密算法：JDK 11增加了对ChaCha20和Poly1305加密算法的支持，这些算法在网络通信中用于提供安全性和隐私。<br>
7. 飞行记录器：JDK 11引入了飞行记录器（Java Flight Recorder），这是一个用于收集和分析JVM运行时数据的工具。<br>
8. 默认字符编码为UTF-8：在JDK 11中，平台的默认字符编码被设置为UTF-8。<br>
9. 废弃Nashorn JavaScript引擎：JDK 11废弃了Nashorn JavaScript引擎，该引擎在Java 8中引入，用于在JVM上运行JavaScript代码。<br>
10. 其他改进和增强：JDK 11还包括对模块系统的改进、对Java编译器（javac）的优化、对Java文档工具（javadoc）的更新等。<br>

        </div>
        
      </el-collapse-item>
      <el-collapse-item title="&nbsp &nbsp Spring前瞻" name="2">
        <div>
          1. GraalVM原生图像支持：Spring Boot 3现在支持GraalVM原生图像，允许开发者将Spring Boot应用程序转换为内存占用更小、编译更快的原生图像。<br>
2. Log4j2增强：Log4j2日志工具包括了一些改进，如特定于配置文件的配置、环境属性查找和Log4j2系统属性。<br>
3. 改进的@ConstructorBinding检测：对构造函数绑定的改进使得使用@ConfigurationProperties类时更加简单，简化了代码。<br>
4. Micrometer更新：Micrometer监控工具包括了一些增强和改进，如自动配置Micrometer观察API、Micrometer跟踪和Micrometer的OtlpMeterRegistry。<br>
5. Prometheus支持：Spring Boot 3为Prometheus Exemplars和Push Gateway提供了自动配置，可以在关闭时进行PUT操作。<br>
6. 其他更新：包括新的Elasticsearch Java客户端的自动配置、Apache HTTP客户端的自动配置、@SpringBootTest注解的改进等。<br>
        </div>
      </el-collapse-item>
      <el-collapse-item title="&nbsp &nbsp MyBatis版本新特性" name="3">
        <div>
          1. MyBatis 3.5.16 (2024年4月2日)<br>
   - MyBatis 是一款优秀的持久层框架，支持自定义 SQL、存储过程以及高级映射。它免除了几乎所有的 JDBC 代码以及设置参数和获取结果集的工作。MyBatis 可以通过简单的 XML 或注解来配置和映射原始类型、接口和 Java POJO 为数据库中的记录。<br>
2. MyBatis-Plus 3.5.5 (2023年8月10日)<br>
   - 升级 MyBatis 至 3.5.13, MyBatis-Spring 至 2.1.1。<br>
   - jsqlparser 提供统一解析类，可配置解析函数，并加入缓存选项。<br>
   - 增加Sequence初始化debug日志。<br>
   - 参数填充器支持多参数填充。<br>
   - BaseMapper新增selectMaps(page, wrapper)与selectList(page, wrapper)方法。<br>
   - 乐观锁字段支持 java.time.Instant。<br>
   - wrapper#apply支持配置mapping。<br>
   - 调整 QueryWrapper 需要主动开启检查 SQL 注入过滤。<br>
   - 新增星瑞格数据库支持。<br>
   - updateWrapper#setSql方法支持动态入参参考wrapper#apply方法。<br>
   - 自动 SQL 维护 DDL 支持 SQL 执行存储过程。<br>
   - ktWrapper加强泛型限制。<br>
   - 修复多个问题，包括在选择springdoc文档注释时entity描述异常、主键的IdType为AUTO情况下生成sql错误问题、租户插件支持update set subSelect的情况等。<br>
3. MyBatis-Plus 3.0 版本<br>
   - 基于JDK8，提供了 lambda 形式的调用。<br>
   - 要求 JDK 8+，Maven 或 Gradle。<br>
   - 发布了适用于 Spring Boot2 和 Spring Boot3 的不同依赖版本。<br>
4. MyBatis 3.5.11 (2022年9月18日)<br>
   - 修复了两处 bug：<br>
     - OGNL 内部函数调用的问题。<br>
     - 即使设置了 returnInstanceForEmptyRow = TRUE，仍然没有生效的问题。<br>
这些更新包括了新特性、修复和一些版本升级。如需更详细的更新信息，建议访问 MyBatis 的官方网站或相关文档。<br>

        </div>

      </el-collapse-item>
      <el-collapse-item title="&nbsp &nbsp 等待更新" name="4">
        <div>
          Decision making: giving advices about operations is acceptable, but do
          not make decisions for the users;
        </div>
        <div>
          Controlled consequences: users should be granted the freedom to
          operate, including canceling, aborting or terminating current
          operation.
        </div>
      </el-collapse-item>
    </el-collapse>
  </div>
  <el-row>
    <el-col :span="6">
      <el-statistic title="博客访问用户" :value="1000000" />
    </el-col>
    <el-col :span="6">
      <el-statistic :value="4">
        <template #title>
          <div style="display: inline-flex; align-items: center">
            已上传的博客条数
            <el-icon style="margin-left: 4px" :size="4">
              <Male />
            </el-icon>
          </div>
        </template>
        <template #suffix>/100</template>
      </el-statistic>
    </el-col>
    <el-col :span="6">
      <el-statistic title="总文章点赞量" :value="outputValue" />
    </el-col>
    <el-col :span="6">
      <el-statistic title="总评论条数 number" :value="1">
        <template #suffix>
          <el-icon style="vertical-align: -0.125em">
            <ChatLineRound />
          </el-icon>
        </template>
      </el-statistic>
    </el-col>
  </el-row>
      </el-main>
    </el-container>
  </div>
  </div>
  
</div>
</template>
<script>
import Nav from '../components/Nav.vue'
import { ref } from 'vue'
import { useTransition } from '@vueuse/core'
import { ChatLineRound, Male } from '@element-plus/icons-vue'

const source = ref(0)
const outputValue = useTransition(source, {
  duration: 1500,
})
source.value = 172000
export default{
  components:{
    Nav
  }
}
</script>
<style scoped>
.container{
  position: fixed;
  background-image: linear-gradient(135deg, #fdfcfb 0%, #e2d1c3 100%);

  margin-top:60px;
  left:0;
  top:0;
}
.normal{
  background-image: linear-gradient(135deg, #fdfcfb 0%, #e2d1c3 100%);
}
.el-carousel__item {
  color: #475669;
  opacity: 1;
  line-height: 2000px;
  margin: 1;
  text-align: center;


}

.el-carousel__item:nth-child(1) {
  background-image: url(./src/assets/images/banner1.jpg);
  background-size: cover; /* 覆盖整个item，可能会裁剪 */
  background-position: center; /* 将图像居中 */
  background-repeat: no-repeat; /* 确保图像不重复 */
  height: 100%; /* 高度设置为100% */
}

.el-carousel__item:nth-child(2) {
  background-image: url(./src/assets/images/banner2.jpg);
  background-size: cover; /* 覆盖整个item，可能会裁剪 */
  background-position: center; /* 将图像居中 */
  background-repeat: no-repeat; /* 确保图像不重复 */
  height: 100%; /* 高度设置为100% */
}
.el-carousel__item:nth-child(3) {
  background-image: url(./src/assets/images/banner3.jpg);
  background-size: cover; /* 覆盖整个item，可能会裁剪 */
  background-position: center; /* 将图像居中 */
  background-repeat: no-repeat; /* 确保图像不重复 */
  height: 100%; /* 高度设置为100% */

}
.el-carousel__item:nth-child(4) {
  background-image: url(./src/assets/images/banner4.jpg);
  background-size: cover; /* 覆盖整个item，可能会裁剪 */
  background-position: center; /* 将图像居中 */
  background-repeat: no-repeat; /* 确保图像不重复 */
  height: 100%; /* 高度设置为100% */
}

.bannerImg{
    width: 100%;
    height: inherit;
    min-height: 360px;
    min-width: 1400px;
  }
  
.el-aside{
  height: 1000px;
  padding-bottom: 100%;
  overflow: hidden;

  background-color: #DCD9D4; background-image: linear-gradient(to bottom, rgba(255,255,255,0.50) 0%, rgba(0,0,0,0.50) 100%), radial-gradient(at 50% 0%, rgba(255,255,255,0.10) 0%, rgba(0,0,0,0.50) 50%); background-blend-mode: soft-light,screen;
}
.el-col {
  text-align: center;
}
.el-row{
  margin-top: 10%;
}
p{
  font-family:"Microsoft YaHei",微软雅黑,"MicrosoftJhengHei",华文细黑,STHeiti,MingLiu}
  .poem{
    font-size: 126%;
  }
  </style>
