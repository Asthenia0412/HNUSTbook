# 一：学习体系：

1. 基础篇
   1. 基础知识
   2. 快速上手
   3. 部署提交
   4. 运行架构
2. 核心篇
   1. 基本API
   2. 时间语义
   3. 窗口
3. 高阶篇
   1. 处理函数
   2. 状态编程
   3. 容错机制
4. SQL篇
   1. SQL-client
   2. 查询语法
   3. Connector
   4. Catalog
   5. Module

# 二：Flink认知

## 1.Flink的目标：

**Flink的目标：数据流上的有状态计算**

Apache Flink是一个框架和分布式处理引擎，能够对**无界**和**有界**的数据流进行 **有状态计算**。Flink特别适合实时流处理和大规模的数据处理任务，它在保证低延迟的同时，提供了强大的容错和可扩展性。

**事件驱动**

Flink的处理模型是事件驱动的，意味着只有当事件发生时，系统才会进行相应的计算和状态更新。可以类比为“挤牙膏”，只有当挤压发生时，牙膏才会流出来。如果没有事件触发，系统将不会启动计算过程。

**无界数据流**

无界数据流是指没有明确定义结束的数据流。就像现实中的水龙头打开后，水源源不断流出，没有规定什么时候会停止流动。无界数据流的特点是数据源是连续的、无限的，无法预知何时停止。这种流的数据需要不断地进行处理，不可能等到所有数据都到达后再进行计算，因为数据是持续产生的。典型的无界数据流的例子包括Kafka、传感器数据流等。

**有界数据流**

与无界数据流不同，有界数据流具有明确的开始和结束。就像打开水龙头后，水会流到水桶里，一旦水桶满了，水龙头就会关闭，这样水流就结束了。在数据处理中，有界数据流通常表示数据源在某一时刻就会停止输入，数据量是已知且有限的。比如处理一个已知大小的文件、数据库中的历史数据等，通常是有界数据流。

**流式数据**

流式数据是指持续产生并实时处理的数据。这些数据流通常没有明确的终结点，系统需要实时对其进行处理。例如，Kafka流输出的数据是流式的，因为Kafka会不断地从生产者接收数据，并将其传递给消费者。流式数据的特点是系统需要具备实时计算和处理能力。

**批式数据**

批式数据与流式数据相对，它是有界的数据，具有明确的起点和终点。例如，读取一个完整的文件或数据库中的数据是批处理操作，因为文件和数据库的内容在某个时刻就已经确定好了，处理过程通常是一次性进行的。批式数据处理是离线处理的典型模式，它允许系统在一段时间内对所有数据进行批量计算。

**有状态的流处理**

有状态的流处理指的是在流处理过程中，系统能够维持并更新某些状态信息。在实际的应用场景中，许多计算都依赖于历史数据或者中间状态的积累，这时候就需要有状态计算。以统计车流量为例，假设你站在路边，数通过的车辆数，你有两种方法来记录：

1. **增量式状态更新**：每当一辆车经过时，你就把计数器加1。这时，每次都更新“当前车流数”这个状态。
2. **最终结果计算**：你等到所有车辆都通过后，按计数进行统计。

在Flink中，状态是分布式存储的，可以在流处理的过程中不断更新。例如，你可以设计一个Flink应用来进行流式的求和计算。每次接收到一个新的数据（如数字1, 2, 3等）时，Flink会更新其状态（即累加的总和），并将结果输出：

- 输入1，状态更新为1，输出1。
- 输入2，状态更新为3（1+2），输出3。
- 输入3，状态更新为6（1+2+3），输出6。

Flink的有状态流处理不仅仅是内存中的计算，它还支持将状态持久化，存储在外部系统（如远程存储、硬盘、数据库等）中，保证系统容错。这样即使出现故障，也能通过状态恢复机制重新计算。

通过这些功能，Flink能够高效地处理复杂的实时流计算任务，并保持一致性和可靠性。

## 2.Flink的起源：

1.柏林理工大学，在德语中Flink是彩色的松鼠的意思

2.14年后捐赠给Apache，并且完成了项目孵化。后来Alibaba收购Data Artisans公司，

## 3.Flink特点

1.低延迟，高吞吐，结果的准确性和良好的容错性

- 高吞吐和低延迟：每秒处理百万个事件，毫秒级的延迟
- 结果的准确性：Flink提供了 **事件时间(event-time)** 和 **处理时间(processing-time)** 某订单业务：发出订单是在23:59:59，这个就是事件时间，但是你是在第二天1:00:29处理的,这就是处理时间。
-  **精准一次(exactly-once)** 状态一致性保证 。
- 可以连接常用存储系统：Kafka，Hive,JDBC,Redis
- 高可用：本身高可用的设置+与K8s,YARN和Mesos的紧密集成，从故障中心快速恢复和动态扩展任务的能力，Flink可以做到用极少的时间停机，实现7x24小时的运行

## 4.Flink和SparkStreaming的区分

- 本质：

  - Spark以批处理为根本

  - Flink以流处理为根本

    |          | Flink              | Stream     |
    | -------- | ------------------ | ---------- |
    | 计算模型 | 流计算             | 微批处理   |
    | 时间语义 | 事件时间、处理时间 | 处理时间   |
    | 状态     | 有                 | 无         |
    | 流式SQL  | 有                 | 无         |
    | 窗口     | 多、灵活           | 少，不灵活 |
    |          |                    |            |

    

## 5.Flink应用场景

- 电商和市场营销
  - 实时数据报表，广告投放，实时推荐
- IOT
  - 传感器实时采集数据，实时报警，交通运输业
- 物流配送和服务业
  - 订单状态实时更新，通知信息推送
- 银行和金融业
  - 实时结算和通知推送，实时监测异常行为

## 6.Flink的分层API

- SQL **(最高层语言)**
  - Table API **(声明式领域专用语言)**
    - DateStream(流处理)/DataSet(批处理 **(核心APIs)**
      - 有状态流处理 **(底层APIs处理函数)**

**SQL (最高层语言)**

SQL 是一种声明式的查询语言，通常用于处理结构化数据，广泛应用于关系型数据库及大数据处理平台。在大数据环境中，SQL 提供了方便的方式来描述数据的处理操作，而无需关心执行细节。SQL 操作是高度抽象的，适合快速执行批处理和流数据的查询。通过 SQL，用户可以直接描述数据的选择、过滤、聚合、排序等操作。

**特点**：
- 声明式语言，用户指定操作意图，而非具体实现。
- 高度抽象，适用于大数据系统中各种数据处理任务。
- 常用于批处理和流数据的查询。

**示例**：
```sql
SELECT name, age FROM users WHERE age > 25;
```

**Table API (声明式领域专用语言)**

Table API 提供了一种在大数据框架中处理表格数据的声明式编程接口，它比 SQL 更具灵活性，适合流处理和批处理任务。与 SQL 类似，Table API 是声明式的，用户只需要描述想要的操作，系统会自动决定如何执行。它支持复杂的操作，比如连接、聚合和窗口操作，同时能够在流处理和批处理之间提供统一的接口。

**特点**：
- 仍然是声明式语言，操作级别比 SQL 更低，支持更复杂的转换。
- 提供与编程语言（如 Java 和 Scala）更紧密的集成，易于嵌入应用程序中。
- 支持流数据和批数据的统一处理。

**示例**：
```java
Table users = tableEnv.from("users");
Table result = users.filter("age > 25").select("name, age");
```

**DataStream (流处理) / DataSet (批处理) (核心 APIs)**

DataStream 和 DataSet 是大数据处理框架（如 Apache Flink）中的两个核心 API，分别用于流数据和批数据的处理。DataStream 主要用于实时数据流的处理，支持无界数据流的持续计算；DataSet 用于批处理，处理一次性的数据集。与 Table API 相比，DataStream 和 DataSet 提供了更底层、更细粒度的控制，适合需要高性能和复杂流处理的场景。

**特点**：
- DataStream 处理流数据，适用于实时数据流计算。
- DataSet 处理批数据，适用于一次性、有限大小的数据集。
- 提供对数据的更细粒度操作，适合高性能数据处理。

**示例**：
```java
DataStream<String> stream = env.fromElements("event1", "event2");
stream.filter(event -> event.startsWith("e"));
```

**有状态流处理 (底层 APIs 处理函数)**

有状态流处理是在处理每个事件时，系统能够保存和更新一些状态信息。在流处理过程中，用户可以维护状态来对数据流中的事件做出动态响应。例如，可以通过累加状态或计算最近的窗口值来生成响应。在大数据平台中，底层 API 提供了对状态的强大支持，允许开发者通过键控状态、操作符状态等管理流中的状态。

**特点**：
- 流处理系统能够保存和更新状态，允许复杂的事件处理。
- 适用于需要记住历史事件并根据历史事件做出计算的场景。
- 系统提供容错机制以保证状态的一致性和恢复。

**示例**：
```java
KeyedStream<Tuple2<String, Integer>, String> keyedStream = stream.keyBy(0);
keyedStream.process(new KeyedProcessFunction<String, Tuple2<String, Integer>, String>() {
    @Override
    public void processElement(Tuple2<String, Integer> value, Context ctx, Collector<String> out) throws Exception {
        ValueState<Integer> countState = getRuntimeContext().getState(new ValueStateDescriptor<>("count", Integer.class));
        Integer currentCount = countState.value();
        if (currentCount == null) {
            currentCount = 0;
        }
        currentCount += value.f1;
        countState.update(currentCount);
        out.collect(value.f0 + " has total count: " + currentCount);
    }
});
```

## 7.Flink测试用例

```java
import org.apache.flink.api.common.functions.FlatMapFunction;
import org.apache.flink.api.java.tuple.Tuple2;
import org.apache.flink.streaming.api.datastream.DataStream;
import org.apache.flink.streaming.api.environment.StreamExecutionEnvironment;
import org.apache.flink.util.Collector;

public class FlinkTestJob {

    public static void main(String[] args) throws Exception {
        // 设置流处理环境
        final StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();

        // 模拟一个数据流，这里我们使用一个简单的字符串数组作为输入
        DataStream<String> textStream = env.fromElements(
                "Hello Flink",
                "Flink is awesome",
                "Hello world",
                "Flink is fast"
        );

        // 对数据流进行转换操作，计算词频
        DataStream<Tuple2<String, Integer>> wordCounts = textStream
                .flatMap(new Tokenizer())  // 将每行文本拆分为单词
                .keyBy(value -> value.f0)  // 按单词分组
                .sum(1);  // 对每个单词的计数进行累加

        // 打印结果
        wordCounts.print();

        // 启动流处理任务
        env.execute("WordCount Stream");
    }

    // 自定义 FlatMapFunction 来将每行文本拆分为单词
    public static final class Tokenizer implements FlatMapFunction<String, Tuple2<String, Integer>> {
        @Override
        public void flatMap(String value, Collector<Tuple2<String, Integer>> out) {
            // 将文本转换为小写并按空格分割
            String[] words = value.toLowerCase().split("\\W+");

            // 遍历每个单词并输出 (word, 1) 的元组
            for (String word : words) {
                if (word.length() > 0) {
                    out.collect(new Tuple2<>(word, 1));
                }
            }
        }
    }
}
```

你可以看到结果：

```java
13> (flink,1)
3> (awesome,1)
5> (hello,1)
13> (flink,2)
5> (hello,2)
13> (flink,3)
6> (fast,1)
9> (world,1)
16> (is,1)
16> (is,2)
```

> 在 Apache Flink 中，输出结果中的 `13>`, `3>`, `5>` 等前缀表示的是 Flink 任务的并行子任务（subtask）的编号。Flink 是一个分布式流处理框架，它会将任务并行化到多个线程或节点上执行。每个子任务都有一个唯一的编号，用于标识它是哪个并行实例。
>
> - **`13>`**: 表示这是第 13 号子任务处理的输出。
>
> - **`(flink,1)`**: 表示单词 `flink` 的当前计数是 1。
>
> - **`3>`**: 表示这是第 3 号子任务处理的输出。
>
> - **`(awesome,1)`**: 表示单词 `awesome` 的当前计数是 1。
>
> - **`5>`**: 表示这是第 5 号子任务处理的输出。
>
> - **`(hello,1)`**: 表示单词 `hello` 的当前计数是 1。
>
> - **`13> (flink,2)`**: 表示第 13 号子任务处理的单词 `flink` 的计数增加到 2。
>
> - **`5> (hello,2)`**: 表示第 5 号子任务处理的单词 `hello` 的计数增加到 2。
>
> - **`13> (flink,3)`**: 表示第 13 号子任务处理的单词 `flink` 的计数增加到 3。
>
> - **`6> (fast,1)`**: 表示第 6 号子任务处理的单词 `fast` 的计数是 1。
>
> - **`9> (world,1)`**: 表示第 9 号子任务处理的单词 `world` 的计数是 1。
>
> - **`16> (is,1)`**: 表示第 16 号子任务处理的单词 `is` 的计数是 1。
>
> - **`16> (is,2)`**: 表示第 16 号子任务处理的单词 `is` 的计数增加到 2。
>
>   ### 为什么会有多个子任务？
>
>   Flink 的并行度（parallelism）决定了任务会被分成多少个并行子任务。默认情况下，Flink 会根据可用的 CPU 核心数自动设置并行度。每个子任务会独立处理一部分数据。
>
>   在你的例子中，Flink 将任务分成了多个子任务（例如 3、5、6、9、13、16 等），每个子任务负责处理一部分单词的计数。
>
>   ### 如何控制并行度？
>
>   你可以通过以下方式控制 Flink 任务的并行度：
>
>   1. **全局设置**：
>      在 `StreamExecutionEnvironment` 中设置全局并行度：
>
>      
>
>      ```java
>      StreamExecutionEnvironment env = StreamExecutionEnvironment.getExecutionEnvironment();
>      env.setParallelism(4); // 设置全局并行度为 4
>      ```
>
>   2. **局部设置**：
>      对某个算子单独设置并行度：
>
>      
>
>      ```java
>      DataStream<Tuple2<String, Integer>> wordCounts = textStream
>          .flatMap(new Tokenizer()).setParallelism(2)  // 设置 flatMap 的并行度为 2
>          .keyBy(value -> value.f0)
>          .sum(1);
>      ```
>
>   ### 为什么单词的计数分散在不同的子任务中？
>
>   Flink 使用 `keyBy` 对数据进行分组。`keyBy` 会根据单词的哈希值将数据分配到不同的子任务中。因此，同一个单词的所有记录会被分配到同一个子任务中，但不同的单词可能会被分配到不同的子任务中。
>
>   例如：
>
>   - 单词 `flink` 被分配到子任务 13。
>   - 单词 `hello` 被分配到子任务 5。
>   - 单词 `is` 被分配到子任务 16。
>
>   ### 如何去掉子任务编号？
>
>   如果你不希望看到子任务编号，可以将结果收集到一个全局的集合中，然后统一输出。例如，使用 `DataStream#executeAndCollect` 方法将结果收集到本地：
>
>   
>
>   ```java
>   List<Tuple2<String, Integer>> result = wordCounts.executeAndCollect();
>   result.forEach(System.out::println);
>   ```
>
>   这样输出结果将不再包含子任务编号。
>
>   ### 总结
>
>   - 子任务编号（如 `13>`）表示 Flink 任务的并行子任务。
>   - 输出结果中的 `(word, count)` 表示某个单词的当前计数。
>   - 你可以通过设置并行度来控制子任务的数量。
>   - 使用 `executeAndCollect` 可以去掉子任务编号，统一输出结果。
>
> 在Flink的流式处理API中，`.keyBy()`和`f0`是非常常见的概念，它们在流数据的分组和聚合操作中起着重要作用。让我们逐一解释：
>
> ### 1. `.keyBy(value -> value.f0)`
> `keyBy()`是Flink中的一个操作符，用于对数据流中的元素进行分组。它的作用是根据传入的键函数将数据按指定的字段分组，使得后续操作能够按组处理数据。在你的例子中：
>
> ```java
> .keyBy(value -> value.f0)
> ```
>
> 表示按照数据元素的第一个字段（`f0`）进行分组。`keyBy`接受一个函数，它定义了如何从数据元素中提取“键”来进行分组。对于每一个数据元素，Flink会根据该键将其分配到同一个组中。这样，在进行后续操作（如求和、平均值等）时，会在每个组内独立地进行。
>
> ### 2. `f0` 是什么？
> `f0` 是访问元组（Tuple）中第一个元素的字段名称。在Flink中，流数据通常是由一组元组（Tuple）组成的，每个元组包含多个字段。`f0`表示元组的第一个字段，`f1`表示第二个字段，以此类推。
>
> 例如，如果你有一个包含单词和其计数的元组：`Tuple2<String, Integer>`，那么：
> - `f0`是表示单词的字符串（`String`类型）。
> - `f1`是表示计数的整数（`Integer`类型）。
>
> 如果你的流数据是这样一个`Tuple2<String, Integer>`，那么`value.f0`就表示元组中的第一个字段，也就是单词。
>
> ### 3. `.sum(1)` 是什么？
> `sum(1)`表示对数据中元组的第二个字段（即计数字段）进行累加。这是一个聚合操作，会计算每个分组（根据`keyBy`选择的字段）内所有元素的和。
>
> 假设数据流中的元素是`Tuple2<String, Integer>`，例如：
> - ("apple", 1)
> - ("banana", 1)
> - ("apple", 1)
>
> 在执行`keyBy(value -> value.f0)`之后，数据将按单词进行分组，分别是`apple`和`banana`。然后，`.sum(1)`会对每个单词的计数进行求和，得到如下结果：
> - ("apple", 2)
> - ("banana", 1)
>
> 这里的`1`表示我们对元组的第二个字段（即计数字段）进行累加。
>
> ### 完整的解释：
> 1. `.flatMap(new Tokenizer())`：这个操作会将每一行文本拆分成单词。假设你处理的是一段文本流，并且每一行可能包含多个单词。`Tokenizer`类的作用是将每行文本拆分成单词。
> 2. `.keyBy(value -> value.f0)`：这行代码会根据每个元素的第一个字段（即单词）将流中的数据分组。这里的`value.f0`就是每个单词。
> 3. `.sum(1)`：这个操作会对每个单词的计数进行累加。在每个分组内，`1`表示我们对元组的第二个字段（计数）进行求和。
>
> ### 例子代码
> 假设你的数据流是单词及其计数的元组，如下所示：
> ```java
> DataStream<Tuple2<String, Integer>> wordCountStream = source
>     .flatMap(new Tokenizer())  // 拆分每行文本成单词
>     .keyBy(value -> value.f0)  // 按单词分组
>     .sum(1);  // 累加每个单词的计数
> ```
>
> 如果原始数据流是类似这样的：
> ```
> apple 1
> banana 1
> apple 1
> ```
>
> 执行完这些操作后，最终的结果将是：
> ```
> apple 2
> banana 1
> ```
>
> 这样，通过`keyBy`和`.sum(1)`的组合，你实现了按单词进行分组并计算每个单词的总计数。

# 三：Flink部署

## 1.组件认知

Flink提交作业和执行任务，需要几个关键组件

- FlinkClient
  - 代码由客户端获取和转换，提交给JobManager
  - 
- JobManager
  - JobManager是Flink集群中的管事人，对作业进行中央调度管理，它获取到要执行的作业，会进一步转换，将任务分发给众多的TaskManager
- TaskManager
  - 真正干活的人，数据的处理操作就是它们来做的。我们定义的算子，都是部署在TaskManager的

## 2.集群搭建

### 2.1集群启动

**0>集群规划：**

| 节点服务器 | hadoop102               | HaDoop103   | Hadoop104   |
| ---------- | ----------------------- | ----------- | ----------- |
| 角色       | JobManager、TaskManager | TaskManager | TaskManager |

**1> 虚拟机安装 flink-1.17.0 的压缩包**

```sh
cd /opt/software
tar -zxvf flink-1.17.0-bin-scala_2.12.tgz -C /opt/module/
# z：gzip解压 x：解压 v：详细 f：指定文件
# -C /opt/module/：将解压的文件放到 /opt/module/ 目录。
```

```sh
cd /opt/module/flink-1.17.0/
ls

##产出：
bin  conf  examples  lib  LICENSE  licenses  log  NOTICE  opt  plugins  README.txt
# bin 存放启动脚本和关闭脚本
# examples 是官方提供的案例
# conf 存放配置文件，里面最重要的是 flink-conf.yaml
# lib 存放依赖的 jar 包
```

**2> 修改集群配置**

编辑 `flink-conf.yaml` 配置文件：

```sh
vim /opt/module/flink-1.17.0/conf/flink-conf.yaml
```

修改以下配置项：

```yaml
# JobManager 的地址
# 0.0.0.0 代表所有机器都可以访问
jobmanager.rpc.address: hadoop102
jobmanager.bind-host: 0.0.0.0
rest.address: hadoop102
rest.bind-address: 0.0.0.0

# TaskManager 地址：修改为当前机器名
taskmanager.bind-host: 0.0.0.0
taskmanager.host: hadoop102
```

编辑 `workers` 文件：

```sh
vim /opt/module/flink-1.17.0/conf/workers
```

添加集群中的各节点：

```sh
hadoop102
hadoop103
hadoop104
```

编辑 `master` 文件：

```sh
vim /opt/module/flink-1.17.0/conf/master
```

设置 JobManager 的地址：

```sh
hadoop102:8081
```

**3> 启动集群**

通过启动 Flink 集群来运行：

```sh
/opt/module/flink-1.17.0/bin/start-cluster.sh
```

你可以使用浏览器访问 JobManager Web 界面：

```sh
http://hadoop102:8081
```

这时候你可以看到集群状态以及作业的执行情况。

```yaml
# Flink 配置文件
# ==========================
# 该文件包含了 Flink 集群的配置设置
# 你可以在运行时或通过 Flink Web UI 来覆盖这些设置

# 1. JobManager 和 TaskManager 配置
# ==============================

# JobManager 进程的数量
# 如果你运行的是独立集群，通常设置为 1
# 对于高可用性（HA）设置，可以有多个 JobManager
jobmanager.rpc.address: "localhost"  # JobManager 可访问的地址
jobmanager.rpc.port: 6123  # JobManager 的 RPC 通信端口
jobmanager.heap.size: 1024m  # JobManager JVM 进程的堆内存大小（默认为 1024MB）
jobmanager.execution.failover-strategy: "region"  # 作业恢复策略
jobmanager.execution.retry-wait: 10s  # 作业失败后重试等待时间

# TaskManager 是运行任务（算子）的地方
taskmanager.heap.size: 4096m  # TaskManager JVM 进程的堆内存大小（默认为 4096MB）
taskmanager.numberOfTaskSlots: 1  # 每个 TaskManager 的任务槽数量（可以根据资源调整）
taskmanager.rpc.port: 6122  # TaskManager 的 RPC 通信端口

# Flink 会根据作业的需求来确定启动多少个 TaskManager
# 如果你使用的是 YARN 或 Kubernetes，这个配置可能会被相关管理器覆盖

# 2. 并行度和资源管理
# ==============================

# 默认并行度定义了每个算子应该执行多少个并行任务（子任务）
# 如果作业图中没有明确指定并行度，Flunk 会使用此默认值
# 如果设置为 `-1`，Flask 会自动根据可用资源来决定
parallelism.default: 4  # 设置作业的默认并行度（如果作业没有显式指定）

# 允许同时执行的作业的最大数量
jobmanager.execution.max-concurrent-job: 2  # 设置最大同时执行的作业数量

# 3. 高可用性配置（可选）
# ==============================

# 启用高可用性时，需要设置以下 JobManager 故障恢复和恢复配置
# Flink 提供了两种高可用性方案：
# 1. ZooKeeper（用于独立 HA 配置）
# 2. Kubernetes（用于 Kubernetes 集群）

high-availability: zookeeper  # 选择高可用性方法（zookeeper 或 kubernetes）

# ZooKeeper 配置用于 HA
high-availability.storageDir: "hdfs://namenode:9000/flink-ha"  # 存储 JobManager 状态的目录
high-availability.zookeeper.quorum: "localhost:2181"  # ZooKeeper quorum 配置

# 4. 日志配置
# ==============================

# Flink 使用 SLF4J 进行日志记录，默认使用 log4j2 配置
# 你可以在这里控制日志级别和输出位置

# Flink 组件的日志级别。可以是 DEBUG、INFO、WARN、ERROR。
# 根据需要调整日志级别
log.level: INFO  # 日志级别（可以是 DEBUG、INFO、WARN、ERROR）

# 定义日志文件的存储路径
# 该目录将包含 Flink 的任务管理器和作业管理器日志
log.file: "/opt/flink/log"  # 存储日志的目录路径

# 5. Shuffle 和网络配置
# ==============================

# Flink 的 Shuffle 负责任务执行过程中数据的交换
# 以下配置控制了 Shuffle 的内存和网络缓冲区

# 用于网络通信（包括 Shuffle、广播等）的内存缓冲区大小
taskmanager.network.memory.fraction: 0.1  # 分配给 Shuffle 内存的总内存比例

# 用于网络交换的缓冲区大小
taskmanager.network.buffer-size: 64kb  # 网络缓冲区大小

# 是否使用基于文件的缓冲区进行 Shuffle 操作
taskmanager.network.preferred-network-buffer-size: 64kb  # Shuffle 的首选网络缓冲区大小

# 6. 作业恢复与故障转移配置
# ==============================

# 作业失败后的恢复策略
# 可选值：'region'（仅恢复失败的区域）、'full'（恢复整个作业）、'none'（不做恢复）
jobmanager.execution.failover-strategy: "region"

# 作业失败后重试的次数
jobmanager.execution.retries: 3  # 设置作业失败后的重试次数

# 7. Web UI 配置
# ==============================

# Flink 提供了一个 Web UI 来监控作业执行、指标和系统信息
# 你可以在这里自定义 Web UI 的设置，例如主机和端口

# Web UI 可访问的主机和端口
web.frontend.address: "0.0.0.0"  # Web UI 的主机地址（0.0.0.0 绑定到所有接口）
web.frontend.port: 8081  # Web UI 的端口

# 8. 度量与指标配置
# ==============================

# Flink 支持通过各种后端报告度量
# 你可以配置系统将度量报告到外部系统，如 Prometheus、InfluxDB 等

# 启用度量报告到外部系统
metrics.reporters: "prometheus, influxdb"  # 配置度量报告器（例如 Prometheus、InfluxDB）

# Prometheus 度量报告器的配置
metrics.reporter.prometheus.class: "org.apache.flink.metrics.prometheus.PrometheusReporter"  # Prometheus 报告器类
metrics.reporter.prometheus.port: 9090  # Prometheus 服务器端口

# 9. 状态后端配置
# ==============================

# Flink 的状态后端决定了作业状态的存储方式
# 针对不同的使用场景，可以配置不同的状态后端

# 使用 RocksDB 状态后端来处理大规模的有状态作业
state.backend: "rocksdb"  # 默认状态后端（可以是 'filesystem'、'memory' 或 'rocksdb'）

# 状态存储路径（适用于 FileSystem 或 RocksDB 后端）
state.savepoints.dir: "hdfs://namenode:9000/flink-checkpoints"  # 状态恢复的保存点目录路径

# 10. 杂项设置
# ==============================

# 单个算子的最大任务尝试次数（默认值为 1）
taskmanager.max-flink-heap-size: 4096m  # TaskManager JVM 堆的最大大小

# 作业在执行过程中发生故障时是否取消
jobmanager.execution.cancel-job-on-failure: true  # 作业失败时是否取消当前作业

```

> 在 Apache Flink 项目中，Maven 依赖的 `provided` 作用域是一个非常重要的概念，尤其是在开发和调试阶段。以下是关于 `provided` 作用域的详细解释，以及如何让 IntelliJ IDEA 正确读取 `provided` 依赖。
>
> ---
>
> ### 1. **`provided` 依赖的作用**
> 在 Maven 中，`provided` 作用域表示该依赖在编译和测试时可用，但在运行时由外部环境（如容器或集群）提供。具体来说：
> - **编译和测试**：`provided` 依赖会被包含在类路径中，确保代码可以正常编译和运行测试。
> - **打包和部署**：`provided` 依赖不会被包含在最终的 JAR 文件中，因为假设目标环境已经提供了这些依赖。
>
> #### 在 Flink 中的应用
> Flink 的核心依赖（如 `flink-java` 和 `flink-streaming-java`）通常设置为 `provided`，因为：
> - Flink 程序通常运行在 Flink 集群中，集群已经提供了这些依赖。
> - 如果将 Flink 依赖打包到 JAR 文件中，可能会导致依赖冲突或 JAR 文件过大。
>
> ---
>
> ### 2. **Maven 中的 `provided` 依赖示例**
> 以下是一个典型的 Flink 项目的 `pom.xml` 文件片段，展示了 `provided` 依赖的用法：
>
> ```xml
> <dependencies>
>     <!-- Flink 核心依赖 -->
>     <dependency>
>         <groupId>org.apache.flink</groupId>
>         <artifactId>flink-java</artifactId>
>         <version>1.15.0</version>
>         <scope>provided</scope>
>     </dependency>
>     <dependency>
>         <groupId>org.apache.flink</groupId>
>         <artifactId>flink-streaming-java_2.12</artifactId>
>         <version>1.15.0</version>
>         <scope>provided</scope>
>     </dependency>
> </dependencies>
> ```
>
> ---
>
> ### 3. **IDEA 读取 `provided` 依赖**
> 默认情况下，IntelliJ IDEA 不会将 `provided` 依赖包含在运行和调试的类路径中。为了让 IDEA 正确读取 `provided` 依赖，可以采取以下方法：
>
> #### 方法 1：修改运行配置
> 1. 打开运行配置：
>    - 点击右上角的运行配置下拉菜单，选择 `Edit Configurations`。
> 2. 添加 `provided` 依赖到类路径：
>    - 在 `Run/Debug Configurations` 窗口中，选择你的运行配置。
>    - 在 `Before launch` 部分，点击 `+` 按钮，选择 `Build Artifacts`。
>    - 确保 `provided` 依赖的 JAR 文件被包含在类路径中。
>
> #### 方法 2：使用 Maven 插件
> 通过 Maven 插件，可以在 IDEA 中显式地将 `provided` 依赖包含在类路径中。在 `pom.xml` 中添加以下插件配置：
>
> ```xml
> <build>
>     <plugins>
>         <plugin>
>             <groupId>org.apache.maven.plugins</groupId>
>             <artifactId>maven-dependency-plugin</artifactId>
>             <version>3.2.0</version>
>             <executions>
>                 <execution>
>                     <id>copy-dependencies</id>
>                     <phase>package</phase>
>                     <goals>
>                         <goal>copy-dependencies</goal>
>                     </goals>
>                     <configuration>
>                         <includeScope>provided</includeScope>
>                         <outputDirectory>${project.build.directory}/provided-dependencies</outputDirectory>
>                     </configuration>
>                 </execution>
>             </executions>
>         </plugin>
>     </plugins>
> </build>
> ```
>
> 运行以下命令将 `provided` 依赖复制到指定目录：
> ```bash
> mvn package
> ```
>
> 然后在 IDEA 中手动将这些依赖添加到类路径。
>
> #### 方法 3：使用 IDEA 插件
> 安装并启用 `Maven Helper` 插件，它可以帮助你更方便地管理 `provided` 依赖。
>
> ---
>
> ### 4. **总结**
> - `provided` 依赖在编译和测试时可用，但在打包和部署时由外部环境提供。
> - 在 Flink 项目中，Flink 核心依赖通常设置为 `provided`，以避免打包时的依赖冲突。
> - 通过修改运行配置、使用 Maven 插件或 IDEA 插件，可以让 IDEA 正确读取 `provided` 依赖。
>
> 