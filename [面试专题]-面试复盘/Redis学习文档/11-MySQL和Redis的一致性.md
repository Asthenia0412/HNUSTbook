# MySQL与Redis一致性及缓存策略知识复习

## 一、MySQL与Redis一致性问题

### 场景：电商订单数据不一致

在电商系统中，订单状态（如`order:1001:status`）在Redis缓存中更新为“已支付”，但MySQL中仍为“待支付”，导致用户界面显示错误状态。

#### A. 为什么需要关注一致性？

MySQL作为持久化存储，Redis作为缓存，两者数据不一致会导致业务逻辑错误，影响用户体验。例如，订单状态不一致可能导致重复支付或订单处理失败。

#### B. 一致性问题结构与反馈

- 问题来源

  ：

  - **异步更新**：Redis和MySQL更新顺序不同步。
  - **缓存失效**：Redis未及时更新或过期。
  - **并发竞争**：多线程更新导致数据覆盖。

- 典型表现

  ：

  - 用户查询Redis返回旧数据。
  - MySQL和Redis数据不匹配。

- 用户看到的反馈

  ：

  - Redis数据：

    ```
    redis-cli GET order:1001:status
    "paid"
    ```

  - MySQL数据：

    ```
    mysql> SELECT status FROM orders WHERE id = 1001;
    +--------+
    | status |
    +--------+
    | pending|
    +--------+
    ```

  - 客户端错误：

    ```
    HTTP 500: Order status mismatch
    ```

- 实战操作

  ：

  1. 检查Redis数据：

     ```bash
     redis-cli GET order:1001:status
     ```

  2. 检查MySQL数据：

     ```bash
     mysql -e "SELECT status FROM orders WHERE id = 1001"
     ```

  3. 同步数据（临时修复）：

     ```bash
     redis-cli SET order:1001:status "pending"
     ```

#### C. 面试深入考察应对

1. Q1：一致性问题的根本原因？
   - 答：Redis和MySQL的更新不是原子操作，可能因网络延迟、并发写或缓存失效导致不一致。
   - 深入Q2：如何量化一致性问题的影响？
     - 答：监控Redis命中率（`keyspace_hits/misses`）和MySQL查询QPS（`Queries`）；统计不一致订单比例。
     - 深入Q3：如何在高并发下保证一致性？
       - 答：使用分布式锁（如`SETNX`）控制更新顺序；异步补偿任务校验数据；优先更新MySQL。
     - 深入Q4：强一致性和最终一致性如何选择？
       - 答：强一致性用分布式事务（成本高）；最终一致性用延迟双删或Canal同步，适合高并发场景。

------

## 二、旁路缓存（Cache-Aside）

### 场景：用户查询订单状态频繁穿透

用户频繁查询订单状态，Redis缓存未命中，导致大量请求直达MySQL，数据库QPS激增。

#### A. 为什么需要旁路缓存？

旁路缓存让应用程序控制缓存逻辑，灵活性高，适合读多写少场景，如订单状态查询。但需要开发者处理一致性问题。

#### B. 旁路缓存结构与反馈

- 定义与流程

  ：

  - **读**：先查Redis，命中返回；未命中查MySQL并写入Redis。
  - **写**：更新MySQL，删除或更新Redis。

- 优缺点

  ：

  - 优点：简单，适合灵活场景。
  - 缺点：需手动处理一致性，可能穿透。

- 用户看到的反馈

  ：

  - Redis未命中：

    ```
    redis-cli GET order:1001:status
    (nil)
    ```

  - MySQL查询：

    ```
    mysql> SELECT status FROM orders WHERE id = 1001;
    +--------+
    | status |
    +--------+
    | paid   |
    +--------+
    ```

  - 高QPS：

    ```
    mysql> SHOW STATUS LIKE 'Queries';
    Queries: 10000
    ```

- 实战操作

  ：

  1. 实现读逻辑（Java示例）：

     ```java
     public String getOrderStatus(String orderId) {
         String key = "order:" + orderId + ":status";
         String status = redisTemplate.opsForValue().get(key);
         if (status == null) {
             status = db.query("SELECT status FROM orders WHERE id = ?", orderId);
             redisTemplate.opsForValue().set(key, status, 1, TimeUnit.HOURS);
         }
         return status;
     }
     ```

  2. 实现写逻辑：

     ```java
     public void updateOrderStatus(String orderId, String status) {
         db.execute("UPDATE orders SET status = ? WHERE id = ?", status, orderId);
         redisTemplate.delete("order:" + orderId + ":status");
     }
     ```

  3. 监控缓存命中：

     ```bash
     redis-cli INFO STATS
     ```

#### C. 面试深入考察应对

1. Q1：旁路缓存如何处理穿透？
   - 答：缓存空值（短TTL）；部署布隆过滤器；参数校验。
   - 深入Q2：写操作如何避免不一致？
     - 答：先更新MySQL，后删除Redis；用分布式锁控制并发写。
     - 深入Q3：缓存未命中如何优化？
       - 答：预热热点数据；异步批量加载；增加Redis容量。
     - 深入Q4：如何处理写后读不一致？
       - 答：延迟双删；异步校验任务；优先读MySQL兜底。

------

## 三、写穿（Write-Through）

### 场景：订单状态更新需强一致性

订单支付后需立即更新Redis和MySQL状态，保证用户实时看到“已支付”，不能有延迟。

#### A. 为什么需要写穿？

写穿通过同步更新Redis和MySQL提供强一致性，适合对数据一致性要求高的场景，如订单状态更新。

#### B. 写穿结构与反馈

- 定义与流程

  ：

  - **写**：同时更新MySQL和Redis（事务保证）。
  - **读**：直接读Redis，命中率高。

- 优缺点

  ：

  - 优点：强一致性，读性能高。
  - 缺点：写性能低，Redis和MySQL均需更新。

- 用户看到的反馈

  ：

  - Redis和MySQL一致：

    ```
    redis-cli GET order:1001:status
    "paid"
    mysql> SELECT status FROM orders WHERE id = 1001;
    +--------+
    | status |
    +--------+
    | paid   |
    +--------+
    ```

  - 写延迟：

    ```
    redis-cli MONITOR
    1698765432.123456 [0 127.0.0.1:12345] "SET" "order:1001:status" "paid"
    ```

- 实战操作

  ：

  1. 实现写穿（Java+Spring示例）：

     ```java
     @Transactional
     public void updateOrderStatus(String orderId, String status) {
         db.execute("UPDATE orders SET status = ? WHERE id = ?", status, orderId);
         redisTemplate.opsForValue().set("order:" + orderId + ":status", status, 1, TimeUnit.HOURS);
     }
     ```

  2. 检查一致性：

     ```bash
     redis-cli GET order:1001:status
     mysql -e "SELECT status FROM orders WHERE id = 1001"
     ```

  3. 监控写延迟：

     ```bash
     redis-cli MONITOR | grep "SET order:1001:status"
     ```

#### C. 面试深入考察应对

1. Q1：写穿适合哪些场景？
   - 答：强一致性需求场景，如金融、订单状态；不适合高写QPS场景。
   - 深入Q2：如何优化写穿性能？
     - 答：异步批量写Redis；用Pipeline减少网络往返；优化MySQL索引。
     - 深入Q3：事务失败如何处理？
       - 答：回滚Redis和MySQL；记录失败日志；异步重试。
     - 深入Q4：如何避免写穿的单点瓶颈？
       - 答：分片MySQL和Redis；用代理（如ProxySQL）分流；监控写QPS。

------

## 四、写回（Write-Back）

### 场景：高频订单状态更新

订单状态频繁更新（如物流状态），直接写MySQL压力大，需优化写性能。

#### A. 为什么需要写回？

写回先更新Redis，异步更新MySQL，适合高写QPS场景，减少数据库压力，但可能牺牲一致性。

#### B. 写回结构与反馈

- 定义与流程

  ：

  - **写**：先写Redis，异步批量写MySQL。
  - **读**：直接读Redis。

- 优缺点

  ：

  - 优点：写性能高，适合高频写。
  - 缺点：可能丢失数据（Redis宕机）。

- 用户看到的反馈

  ：

  - Redis更新快：

    ```
    redis-cli GET order:1001:status
    "shipped"
    ```

  - MySQL延迟：

    ```
    mysql> SELECT status FROM orders WHERE id = 1001;
    +--------+
    | status |
    +--------+
    | paid   |
    +--------+
    ```

  - 异步任务日志：

    ```
    [async] Persisted order:1001 to MySQL
    ```

- 实战操作

  ：

  1. 实现写回（Java+Spring示例）：

     ```java
     @Async
     public void updateOrderStatus(String orderId, String status) {
         redisTemplate.opsForValue().set("order:" + orderId + ":status", status);
         asyncTaskExecutor.submit(() -> {
             db.execute("UPDATE orders SET status = ? WHERE id = ?", status, orderId);
         });
     }
     ```

  2. 检查Redis：

     ```bash
     redis-cli GET order:1001:status
     ```

  3. 验证MySQL：

     ```bash
     mysql -e "SELECT status FROM orders WHERE id = 1001"
     ```

#### C. 面试深入考察应对

1. Q1：写回如何保证数据不丢失？
   - 答：Redis启用AOF持久化；异步任务记录日志；失败重试。
   - 深入Q2：异步更新的延迟如何控制？
     - 答：批量写MySQL；优化任务队列（如Kafka）；监控延迟（`async_task_lag`）。
     - 深入Q3：Redis宕机如何恢复？
       - 答：从AOF恢复Redis；校验MySQL数据；异步补偿。
     - 深入Q4：写回和写穿如何选择？
       - 答：写回适合高写QPS、低一致性场景；写穿适合强一致性场景；测试延迟和丢失率。

------

## 五、延迟双删（Delayed Double Deletion）

### 场景：并发写导致不一致

订单状态更新后，Redis缓存未及时删除，高并发下用户读到旧数据。

#### A. 为什么需要延迟双删？

延迟双删通过两次删除Redis缓存，解决写后读不一致问题，适合旁路缓存场景。

#### B. 延迟双删结构与反馈

- 定义与流程

  ：

  - 步骤

    ：

    1. 删除Redis缓存。
    2. 更新MySQL。
    3. 延迟后再次删除Redis缓存。

  - **延迟时间**：根据业务一致性需求（如100ms）。

- 优缺点

  ：

  - 优点：简单，减少不一致窗口。
  - 缺点：增加删除操作开销。

- 用户看到的反馈

  ：

  - 第一次删除：

    ```
    redis-cli DEL order:1001:status
    (integer) 1
    ```

  - MySQL更新：

    ```
    mysql> UPDATE orders SET status = 'shipped' WHERE id = 1001;
    ```

  - 第二次删除：

    ```
    redis-cli DEL order:1001:status
    (integer) 0
    ```

- 实战操作

  ：

  1. 实现延迟双删（Java示例）：

     ```java
     public void updateOrderStatus(String orderId, String status) {
         String key = "order:" + orderId + ":status";
         redisTemplate.delete(key); // 第一次删除
         db.execute("UPDATE orders SET status = ? WHERE id = ?", status, orderId);
         Thread.sleep(100); // 延迟100ms
         redisTemplate.delete(key); // 第二次删除
     }
     ```

  2. 检查删除：

     ```bash
     redis-cli MONITOR | grep "DEL order:1001:status"
     ```

  3. 验证一致性：

     ```bash
     redis-cli GET order:1001:status
     mysql -e "SELECT status FROM orders WHERE id = 1001"
     ```

#### C. 面试深入考察应对

1. Q1：延迟双删如何确定延迟时间？
   - 答：根据读写延迟和业务容忍度（如100-500ms）；监控实际不一致窗口。
   - 深入Q2：延迟双删的性能开销？
     - 答：两次删除