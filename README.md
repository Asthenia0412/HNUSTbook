## 0.前言&&为何要准备这个仓库

- 对本地数据可靠性的不信任(bushi)
- 为湖科大的学弟学妹们提供一些学习方向上的便利
- 更好的了解科大的转专业政策(本仓库仅留存**24年春季学期**转专业资料——历年情况不一，还请多方考证)。
- 共享知识,优化自学体验
- **ps:如果有帮助的话,可以在右上角star一下！**
- 我的博客：
  - [Asthenia0412 的个人主页 - 动态 - 掘金 (juejin.cn)](https://juejin.cn/user/2685482018803200)->**访问我的博客,共享我的知识储备！**

- 面试算法刷题:
  - 记录了部分文字题解[Metaphysics - 力扣（LeetCode）](https://leetcode.cn/u/metaphysics-u/)
  - 视频题解：**抖音-Asthenian** (算法板子很容易遗忘-我往往会录制视频-在需要复习时,从我的视频中找回曾经理清的思路-我很缺乏算法上的天赋-这是一个很笨的办法) 截止到**2025/1/3**-已经**更新到了P328**

## 1.本仓库涵盖的知识体系

- Web2开发方向
  - 前端开发
    - 基础知识：Html/Css/JavaScript
    - 进阶知识：Vue.js/Vite/Vue-router/Vuex
  - 后端开发
    - 前置知识：JavaSE/Servlet+Jsp/SpringMVC+SpirngIOC+SpringAOP/SpringBoot/JDBC/JPA/Mybatis/Mybatis-Plus
    - 独立中间件：
      - 数据存储：
        - 关系型：MySQL
        - 非关系型：MongoDB/Redis
      - 搜索引擎：
        - ElasticSearch
      - 消息中间件：
        - RabbitMQ(安全/低吞吐)/Kafka(会丢数据-日志存储/高吞吐)/RocketMQ(安全/高吞吐)
    - 微服务中间件：
      - 异构数据转化：Canal
      - 服务注册中心：Nacos(注册+配置)/Eureka(注册)/ZooKeeper(集成Curator)(注册)
      - 配置中心：SpringCloud-Config
      - 分布式事务：Seata
      - 流量控制：Sentin el(优选)/Hystrix(不建议)
      - RPC(同步调用)：Dubbo/Feign
      - 负载均衡：Ribbon/GateWay/Nginx
      - 高可用保证：MHA(服务MySQL) Redis-Sentinel(服务Redis-全量存储) Redis-Cluster(服务Redis-分片存储) 布隆过滤器(服务Redis)/MGR(MHA替代品)/ProxySQL(实现读写分离)
    - 中间件与服务同步机制：
    
      - 异构数据转化：
        - FlinkCDC：MySQL与ElasticSearch数据同步。通过状态表实现"伪双写一致性"——仅展现双写同步的数据
      - 同构数据同步：
        - ShardingJDBC(分库分表) + ProxySQL(读写分离) + MGR集群(联结Master服务和Slave服务)
    - 项目部署与运维：
      - 代码存储：GitLab
      - 虚拟化与部署：Docker/K8s
      - 镜像仓库：DockerHub/Harbor
      - CI/DI：Jenkins
      - 服务更新：蓝绿发布/红黑发布/灰度发布
      - 服务检测：Arthas
      - OOM排查：VisualVM
      - 并发测试：Jmeter
    - 分布式数据库设计：
      - 主键处理：优选雪花和leaf，拒绝UUID和单库自增主键
      - 分库分表：阿里-MyCat/apache-ShardingSphere
      - 列式数据库：Cassandra(写入快更新慢)
    - 序列化策略：
      - Jackson-SpringBoot内置
      - Hessian-Dubbo内置
      - Protocal Buffers-Google
    - 日志收集策略：
      - 多服务内嵌LogStash+ElasticSearch+Kibana `内嵌LogStashCPU开销高`
      - 多服务代码耦合LogStashTCPSocketAppender依赖+统一发给LogStash+ElasticSearch+Kibana`LogStashTCPSocketAppender代码耦合大`
      - 多服务Beats监听+统一发给LogStash+ElasticSearch+Kibana`Beats监听的导出数据单一化,不可导出到多个中间件,于是先导到Kafka,大家从Kafka读数据`
      - 多服务Beats监听+统一发给Kafka+分发给LogStash（以及Redis等其他数据中心）+Kibana`部署成本昂贵`
    - 服务性能指标监控(配合K8s)：
      1. **具体的Service的运行及Exporter**
      2. **数据抽取到 Prometheus**
      3. **部分服务不支持 Export，采用 PushGateway 推送数据**
      4. **数据存储到 TSDB（时序数据库）**
      5. **Grafana 进行数据可视化**
    - 服务调用链路跟踪
      - 基于日志收集：Sleuth&Zipkin(Sleuth负责收集日志,ZipKin的客户端收集当前服务Sleuth产生的日志，并且发送给ZipKin服务端，产出可视化的链路分析结果)
      - 基于Agent收集调用链路：SkyWalking
    - 项目管理与协作开发：
      - JIRA/禅道：多用户协作开发：测试/项目经理/开发
    
      
  
  
  
  Web3方向：
  
  - 智能合约（Solidity）
  - 以太坊开发(Go)
  
- 基础技能
  - 使用Python爬虫提高数据获取能力
  
- 面试策略
  - 八股文
    - 计算机网络
    - 操作系统
    - Java Concurrent Util(基础JUC+高并发)
    - Java Virtual Machine
    - Spring源码/Mybatis源码
    - MySQL原理/Redis,MongoDB,ZooKeeper,RabbitMQ,ElasticSearch等中间件的原理分析
  - 常用算法集成
    - 二分法
    - 单调栈
    - 动态规划
    - DFS/BFS/A*
    - 二叉树/链表相关
    - 滑动窗口
    - 数论
  
- 如何更好利用政策
  - 转专业教程-基于科大的转专业政策给出的详细步骤可行性探索
  - 如何尽可能在大一上学期得到高绩点转专业（譬如3.94/4.00）

## 2.仓库的更新状态

**更新时间请见Commit部分**

## 3.推荐给学弟学妹们的学习进度表

- **大一上学期：**

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

- **大一下学期：**

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

- **大二上学期：**

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
  
- **恭喜你，完成了上述知识点的学习。**

- 现在的你，技术的**广度**已经cover互联网后端开发的**实习需求**了。

- 但是就技术的深度和对业务的理解而言，这仅仅是一个**开始**。

- 接下来的日子里，你应该：

  - **通过具体场景中的架构设计，逐渐把握中间件之间的关联。**
    - Such as：电商业务中，使用Canal捕获MySQL **订单表** **库存表** 变更，捕获事件并且发送到RocketMQ。整合了ElasticSearch的检索业务从MQ中拉取信息，完成用户查询操作。(Canal实现异构数据转化/上下游服务通过MQ解耦/金融场景下的MQ选型/幂等性处理/顺序消费/消息不丢失)
  - **基于业务拓展需求，逐渐建立善用设计模式的思考路径**
    - Such as：在某款流控自研中间件的开发中，你使用 **责任链模式** 构建了一套可拓展slot的过滤器链，能够根据 **业务需求的变更** 自定义 **限流策略** 与 **熔断降级策略** 

- 遗憾的是，我对技术和业务的理解是**浅薄**的。这意味着你**无法**从我这获取到体系化的架构思考。但是我有记录学习日志的习惯，兴许我后续琐碎的填补深度的技术学习历程，可能对你有一丝微薄的帮助。

- 如果你希望了解更多，你可以下载我的日报文件，我会定期更新这份日报。

- Readme在此处就已经结束了，希望我的 **来时路** 能对你的 **成长路径构建** 发挥一丝微不足道的作用。

- **也欢迎你在issue部分补充更多的业务场景/学习资料，我们共同进步。**



- 
