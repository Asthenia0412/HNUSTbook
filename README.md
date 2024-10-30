## 0.为什么要准备这个仓库？

A.对本地数据可靠性的不信任

B.为湖科大的学弟学妹们提供一些学习方向上的便利

C.共享知识,优化自学体验

**ps:如果有帮助的话,可以在右上角star一下！**

[Asthenia0412 的个人主页 - 动态 - 掘金 (juejin.cn)](https://juejin.cn/user/2685482018803200)->访问我的博客,共享我的知识储备

D.面试算法刷题:

- 记录了部分文字题解[Metaphysics - 力扣（LeetCode）](https://leetcode.cn/u/metaphysics-u/)
- 视频题解：**抖音-Asthenian** (算法板子很容易遗忘-我往往会录制视频-在需要复习时,从我的视频中找回曾经理清的思路-我很缺乏算法上的天赋-这是一个很笨的办法) 截止到**2024/10/13**-已经**更新到了P246**

## 1.本仓库涵盖的知识体系

- Web2开发方向
  - 前端开发
    - JavaScript
    - Html
    - Css
    - Vue
    - React
    - ElementUI
    - ...
  - 后端开发
    - JavaSE本体
    - JavaWeb
    - SSM
      - SpringIOC+SpringAOP+SpringMVC+Mybatis
    - SpringBoot
    - 中间件
      - Redis
      - MongoDB
      - ElasticSearch
      - RabbitMQ
      - ZooKeeper
      - Mysql
- Web3开发方向
  - 智能合约
- 基础性技能
  - 使用Python爬虫提高数据获取能力
- 面试策略
  - 八股文
  - 常用算法集成
- 如何更好利用政策
  - 转专业政策
  - 如何尽可能在大一上学期得到高绩点转专业（譬如3.94/4.00）

## 2.仓库的更新状态

随缘更新..

## 3.推荐给学弟学妹们的学习进度表

- 大一上学期

  - 6-9月:

    - C语言基本语法
    - 学会使用魔法上网
    - 注册Github账号,学会Git clone/commit/push/pr
    - 学会使用Typora
      - 真的：Markdown结构的文件比word优雅多了.....你会喜欢的
    - 想明白到底是要就业还是保研
      - 保研：刷绩点，不用往下看了,把绩点刷满比下面的技术都重要,因为你不打算本科就业.下面的技术学习对你毫无意义...
      - 就业：上课按自己计划走，所有课程期末突击，及格就行。一定要确保下面提到的技术栈你能融会贯通,拓宽自己的技术视野。虽然自己干的是后端,但是对于前端和web3的相关知识都要有所涉猎。譬如：你在工作任务需要将后端服务和区块链结合,倘若你没有Web3的合约知识,那么如何实现业务功能呢？

  - 10月-次年1月:JavaSE核心内容：**Java基本特性**/**集合**/**IO流**/**JUC**/**JVM相关八股文**

  - (寒假)次年1月-2月:

    - **HTML**/**CSS**/**JavaScript**/**Vue2**/**Echarts**等组件/**ElementUI**
    - 掌握Linux基本命令，学会在Vmware部署自己的Linux：Ubuntu/Centos
    - 学会使用FTP工具进行文件传输,学会在Vmware上部署Redis,Docker,Mysql.并且在本地使用Navicat等工具连接虚拟机中的服务

    

  - 在寒假开始力扣每日一题:优先刷二叉树的相关BFS/DFS/前缀和/二分/堆/栈/数组和字符串相关

    - 此部分瞄准面试需求,多看大厂面经,切记不要好高骛远花大量时间到算法训练,因为你的目的是找工作,算法钻研太深,如果ACM没拿到牌子,就业会炸的.

- 大一下

  - 3月-4月：JavaWeb
    - Tomcat的运行机制
    - jsp
    - 学习Docker使用
      - Windows启动如何开启HyperV
      - 学会如何安装WSL
      - 本地安装docker 掌握docker基本命令
      - 安装Docker DeskTop 学习如何管理镜像(为微服务项目大量中间件管理做准备)
      - 熟练掌握docker-compose.yml阅读与配置(Kafka,Mysql,Redis等中间件的镜像通过此文件来组织)
  - 5月：SpringIOC+SpringAOP+SpringMVC+Redis+Mybatis学习
  - 6月：整合SSM到SpringBoot,结合视频完成苍穹外卖的后端部分,依托寒假的前端学习完成苍穹外卖的前端部分
  - 7月(暑假开始)：
    - 强化八股文学习：重点关注JVM与JUC，看集合源码，了解Redis常见八股
    - 基于Vue2基础学习Vue3,回顾前端知识点.结合LeetCode的Javascript特训,强化函数式编程思想.
    - 强化网络编程部分：在IO基础上学习NIO，掌握Netty基本API.至此：你应该掌握使用IO,NIO,Netty三种不同封装程度的技术来实现BS架构通讯
    - 阶段标准：此时力扣应该已经刷满200题左右（如果你从寒假开始坚持的话）
    - 设计模式基本认知：
      - 手搓单例模式(懒汉式,饿汉式)
      - 了解建造者模式应用：通过内部类实现.builder()的链式调用
      - 了解适配器模式（在Web开发中经常使用）
      - 了解装饰器模式（IO流常用）
      - 了解观察者模式（ZooKeeper）
  - 8月：
    - Dubbo学习
    - SpringCloud项目概览
      - 结合Docker完成中间件部署
      - 注册中心/网关/熔断机制/分布式锁等功能
      - 学会拆分单体项目-使用微服务思想
    - ZooKeeper对Java开放的API与ZooKeeper的部署
    - Kafka使用对Java开放的API与Kafka的部署
    - RabbitMQ的Java客户端API
    - 掌握MyBatis-plus的十一种常见用法or拓展插件
      -  分页实现
      -  条件构造器（替代Mybatis中的XML配置动态SQL）
      -  代码生成器（基于本地实体类来生成数据库对应字段的controller service mapper）
      -  逻辑删除（实际没删,但是无法让该行被查询,用于标记历史数据）
      -  性能分析插件(测试环境用于评估SQL性能,生产环境要关闭)
      -  自动填充功能(譬如插入时间与更新时间)
      -  乐观锁(版本号机制的单体项目实现)
      -  序列化器
      -  数据权限设置(公司分部门执行不同sql)
      -  多数据源(主从节点)
      -  SQL注入器(在不改变现有代码情况下,注入新的SQL实现功能);
    - NoSql的强化学习
      - MongoDB
      - ElasticSearch
      - Redis-深入学习八股知识
    - JVM调优的基本掌握：
      - 堆内存与MetaSpace内存
      - 堆外内存
      - 线程分析之Dump分析
      - Java问题排查的相关Linux命令
      - 在线调试-Arthas
      - 使用IDEA本地调试与远程调试
      - Java动态调试技术原理

- 大二上学期：

  - 9月-10月：
    - MongoDB认知与crud
    - Redis复习常见八股
    - RabbitMQ认知建立,记忆相关八股
    - 二十三种设计模式复盘
    - SpringIOC,SpringAOP源码分析,结合设计模式的思考
    - JUC的思考,高并发相关的八股文
    - Netty知识框架,动手复现了一个基于Netty的NIO聊天室项目
    - 了解了配置K8s的基本yml,通过电商项目了解了配置Yml的流程
    - 对MySQL的八股进行了细化
    - 较为系统的阅读了Maven实战,了解了复杂项目中的Maven布置
    - 简单了解了部分Python语法
    - 建立了对SpringCloud Netflix的基本认知
  - 10.1-10.15
    - 阅读了《MySQL数据库原理、设计与应用》-回忆6个月前学习的SQL-加深记忆
    - 复习了HTTP相关八股，拓展了IP相关八股
    - Websocket与SSL层相关八股
    - 学习了操作系统的部分知识
    - 学习设计模式-场景题
    - 复习了MongoDB-过往记忆流失严重-及时补齐
    - 学习了与Unsafe类的CAS相关的计组结构-譬如CPU中组件构成
    - 学习了基本的Flutter语法,实现简单的多页面跳转安卓程序【该方向学习搁置-就业前景不明朗-同生态位技术为Vue3+Uniapp】
  - 10.16-10.29：
    - Spring与源码
      - SpringMVC源码与Web启动流程（从web.xml到DispatcherServlet）
      - Resource,ResourceLoader,ResourcePatternResovler,DocumentLoader,MetaDataLoader,MetaData,
      - TypeFilter,Conditional,SpringValidator
      - ConversionService,Parser,Converter,Printer
      - 配置类实现Adapter接口实现适配器模式《Springboot in action》
      - SpringDataJPA与MybatisPlus注解上的差异,全ORM与半ORM
    - Web技术
      - JSP与Servelt相关复习(.Listener-Filter)：《JSP&Servlet学习笔记(第二版)》-林信良
      - Vue2工程化《Vue.js实战》-黑马
    - JUC
      - Thread三种创建方式,Thread源码,Thread生命周期
      - 函数式接口@FunctionInterface
      - 同步异步,阻塞非阻塞,线程与进程结构
      - 线程改变状态的方法(yeild,sleep,join)
      - 线程池架构/四种便捷线程池/自定义线程池与若干参数/线程池调度流程/任务阻塞队列/调度器钩子方法/线程池四种拒绝策略/线程池优雅关闭/IO与CPU密集型线程池差异/ThreadLocal演进
      - 线程安全/自增行为的不安全分析/synchronized锁芯分析/生产者与消费者模型
      - synchronized锁芯对象结构与内置锁
      - 无锁-偏向锁-轻量级锁-重量级锁/膨胀过程与状态转化分析/线程通讯三种策略
      - AtomicInteger等基础类/AtomicReferenceArray等数组类/AtomicIntegerFieldUpdater等更新Reference中对象具体元素类
      - 大端与小端，X86架构用小端,协议传输多用大端
    - 工具知识
      - RedisInsight-在Windows上调用虚拟机中的Redis服务
      - EoLink Apikit-API管理平台,前后端统一接口设计
      - Ruoyi框架的代码生成器使用策略,以及如何配置生成的代码到前后端项目中
    - 中间件与分布式架构
      - MongoDB复习
      - BASE理论/最终一致性/CAP
      - 复习SpringCloud NetFlix，Github上传了实验Lab，为Eureka的服务端与客户端《SpringCloud微服务架构开发》-黑马
      - 拆解了模拟X的微服务项目，归档了服务分类与maven依赖架构
      - 对Dubbo做了简单入门,认知了SpringCloudAlibaba与Netflix差异,譬如Nacos与Sentinel
      - Neo4j入门,复习部分ElasticSearch
      - redis集群部分,Redis的RDB卡顿
      - TCP第三次握手无回复导致的SYN FLOOD攻击
      - 
