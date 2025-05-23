> 本系列视频的配套文档均可在Github的Repo：HNUSTBook中下载

> 为什么想谈一谈Netty？
>
> 比较常见的互联网应聘的简历出装是：业务项目+轮子项目(中间件项目)

> 其中的业务项目不必多说：SpringCloud全家桶+各类MQ+分布式事务/ID/搜索/存储系统
>
> 而轮子项目：形如手写RPC框架/手写MQ。会涉及到多机器的网络通信问题——我们需要学习Netty来为这些工作赋能。
>
> 比如我们要写一个MQ项目：会涉及到Producer、Broker、Consumer三者。那么彼此之间的通信如何进行呢？采取同步还是异步？阻塞还是非阻塞？序列化如何实现？TCP协议带来的粘包和拆包问题如何处理？

> **Netty的出现，就是为了解决这些复杂的问题，替代NIO来帮助你更好进行网络通信的开发的。**
>
> Netty的学习资料并不成体系，我在学习与基于Netty开发项目的过程中也遇到许多挫折。因此：我想试图用一种更贴近正常人思维模式的角度来分享我对Netty的理解。希望这一切对你有帮助！！



> 在学习之前：你应该理解NIO的基本概念。对Buffer/channel/Selector有基本的认知。对同步非阻塞的编程策略有自己的理解。

> #### **Channel（通道）**
>
> - 
>
>   核心概念：Channel 是对标传统 OIO（阻塞式 I/O）中的 和OutputStream的抽象，但 Channel 是双向的（可读可写），而 Stream 是单向的（InputStream只能读，OutputStream只能写）。
>
>   - 常见实现类：
>     - `SocketChannel`：用于 TCP 客户端通信（支持非阻塞模式）。
>     - `ServerSocketChannel`：用于 TCP 服务端监听（通过 `accept()` 返回 `SocketChannel`）。
>     - `DatagramChannel`：用于 UDP 通信。
>     - `FileChannel`：用于文件操作（**不支持非阻塞**，也未实现 `SelectableChannel` 接口，因此无法与 `Selector` 配合使用）。
>   - 特殊说明：
>     - `FileChannel` 虽然功能强大（如内存映射文件 `MappedByteBuffer`、零拷贝 `transferTo/transferFrom`），但因设计限制无法融入 Netty 的 Reactor 模型。
>
> #### **Buffer（缓冲区）**
>
> - 核心概念：NIO 是面向缓冲区的（Buffer-Oriented），而 OIO 是面向流的（Stream-Oriented）。Buffer 本质是一块内存区域，提供结构化数据读写能力。
>   - 两种状态：
>     1. **写模式**：数据写入 Buffer（`put()` 操作），`position` 指针移动。
>     2. **读模式**：调用 `flip()` 切换为读模式，数据从 Buffer 读取（`get()` 操作）。
>   - 关键属性：
>     - `capacity`：缓冲区容量（固定不变）。
>     - `position`：当前读写位置。
>     - `limit`：读写边界（写模式下等于 `capacity`，读模式下等于有效数据长度）。
>   - **常用类型**：
>     `ByteBuffer`（最常用）、`CharBuffer`、`IntBuffer` 等，支持堆内（`allocate()`）和堆外（`allocateDirect()`）内存分配。
>
> #### **Selector（选择器）**
>
> - 核心作用：基于事件驱动的多路复用机制，单线程可管理多个 Channel 的 I/O 事件（如连接、读、写），避免线程阻塞。
>   - 关键组件：
>     - `SelectionKey`：绑定 Channel 与感兴趣的事件（`OP_ACCEPT`、`OP_READ` 等）。
>     - `selectedKeys()`：返回已就绪的事件集合。
>   - **优势**：
>     大幅减少线程资源消耗（对比 OIO 的“一连接一线程”模型）。

# 深入浅出 Reactor 模式：从基础到 Netty 的应用

## 引言：什么是 Reactor 模式？

在学习高性能网络编程时，你是否曾思考：**如何高效地处理成千上万的并发连接？** 传统的网络编程方式通常为每个客户端连接分配一个线程，但当连接数量激增时，这种方式会导致资源耗尽、性能瓶颈。Reactor 模式（反应器模式）是一种事件驱动的设计模式，旨在以高效、可扩展的方式处理大量并发连接。

**思考题 1**：在传统的多线程模型中，每个客户端连接都独占一个线程。如果有 10,000 个连接，每个线程占用 1MB 内存，你需要多少内存？这种方式的局限性是什么？在Linux中，我们是否需要做额外的配置，让Linux支持10000个FD呢？

Reactor 模式通过事件驱动和异步处理，解决了传统阻塞式 I/O 的低效问题。它将 I/O 事件分发给相应的处理程序，类似于一个“事件分发中心”，让系统能够以较少的资源处理更多连接。

## Reactor 模式的核心思想

Reactor 模式的核心是将 I/O 操作分解为事件驱动的处理流程：

1. **事件循环**：一个或多个事件循环负责监听 I/O 事件（如连接建立、数据到达等）。
2. **事件分发**：当事件发生时，Reactor 将事件分发给注册好的处理程序（Handler）。
3. **非阻塞 I/O**：所有 I/O 操作都是异步的，避免线程阻塞。

**思考题 2**：如果一个服务器需要同时处理多个客户端的请求，阻塞 I/O 和非阻塞 I/O 在性能上的主要区别是什么？

与传统的每个连接一个线程的模型相比，Reactor 模式的优势在于：

- **高性能**：通过非阻塞 I/O 和事件驱动，减少线程切换和资源浪费。
- **可扩展性**：单线程或少量线程即可处理大量连接。
- **灵活性**：事件处理程序可以根据业务需求自定义。

## 单线程 Reactor 模式

在单线程 Reactor 模式中，一个线程负责所有的工作，包括：

- 监听新连接（Accept 事件）。
- 监听已连接客户端的 I/O 事件（读、写等）。
- 执行事件对应的业务逻辑。

### 单线程 Reactor 的工作流程

1. **初始化**：Reactor 启动一个事件循环，通常基于 `select`、`poll` 或 `epoll` 等多路复用技术。
2. **事件监听**：Reactor 监听所有注册的 I/O 通道（Channel）。
3. **事件分发**：当某个通道有事件发生（如有数据可读），Reactor 调用对应的处理程序。
4. **业务处理**：处理程序执行具体的业务逻辑（如解析数据、发送响应）。

**示例伪代码**：

```java
while (true) {
    // 监听事件
    events = selector.select();
    for (Event event : events) {
        if (event.isAcceptable()) {
            handleAccept(event); // 处理新连接
        } else if (event.isReadable()) {
            handleRead(event); // 处理读事件
        }
    }
}
```

**思考题 3**：单线程 Reactor 模式在处理 CPU 密集型任务时会遇到什么问题？如何改进？

### 单线程 Reactor 的优缺点

**优点**：

- 简单，易于实现。
- 资源占用低，适合连接数多但业务逻辑简单的场景。

**缺点**：

- 单线程处理所有事件，CPU 密集型任务可能导致事件循环阻塞。
- 无法充分利用多核 CPU 的性能。

## 多线程 Reactor 模式

为了解决单线程 Reactor 的局限性，多线程 Reactor 模式引入了线程池或多个事件循环线程。它的核心思想是将 I/O 事件分发和业务逻辑处理分离。

### 多线程 Reactor 的工作流程

1. **主 Reactor**：一个线程（或少数线程）负责监听新连接（Accept 事件），并将新连接分配给子 Reactor。
2. **子 Reactor**：多个线程组成的事件循环池，每个子 Reactor 负责一组连接的 I/O 事件监听和分发。
3. **工作线程池**：业务逻辑（如数据解析、计算）交给单独的工作线程池处理，避免阻塞事件循环。

**示例伪代码**：

```java
// 主 Reactor
while (true) {
    events = mainSelector.select();
    for (Event event : events) {
        if (event.isAcceptable()) {
            SocketChannel client = serverChannel.accept();
            // 分配到子 Reactor
            subReactor.register(client);
        }
    }
}

// 子 Reactor
while (true) {
    events = subSelector.select();
    for (Event event : events) {
        if (event.isReadable()) {
            // 交给工作线程池处理
            workerPool.submit(() -> handleRead(event));
        }
    }
}
```

### 多线程 Reactor 的优缺点

**优点**：

- 充分利用多核 CPU，提升性能。
- I/O 处理和业务逻辑分离，防止事件循环阻塞。
- 可扩展性强，适合高并发、高负载场景。

**缺点**：

- 实现复杂，涉及线程同步和任务分配。
- 资源占用略高于单线程模式。

**思考题 4**：在多线程 Reactor 中，主 Reactor 和子 Reactor 的职责如何划分？为什么不让主 Reactor 直接处理所有事件？

## Netty 如何基于 Reactor 模式

Netty 是一个高性能的 Java 网络框架，广泛应用于服务器开发。它基于 Reactor 模式，通过精心设计的组件实现了高效的事件处理和并发管理。

### Netty 的核心组件与 Reactor 模式

Netty 的 Reactor 模式体现在以下组件中：

1. **EventLoopGroup**：

   - 对应 Reactor 模式中的事件循环池。

   - Netty 通常使用两个 

     ```
     EventLoopGroup
     ```

     ：

     - **Boss EventLoopGroup**：类似主 Reactor，负责监听连接事件（Accept）。
     - **Worker EventLoopGroup**：类似子 Reactor，负责处理已连接客户端的 I/O 事件（读、写等）。

   - 每个 `EventLoop` 是一个单线程的事件循环，绑定到一组 `Channel`，负责监听和分发事件。

2. **Channel**：

   - 表示一个网络连接或套接字，封装了底层的 I/O 操作。
   - Netty 使用非阻塞 I/O（如 `NioSocketChannel`），与 Reactor 模式的非阻塞要求一致。

3. **ChannelPipeline**：

   - 每个 `Channel` 关联一个 `ChannelPipeline`，用于组织事件处理程序（`ChannelHandler`）。
   - 对应 Reactor 模式中的事件处理程序，负责处理具体的业务逻辑（如解码、编码、业务计算）。

4. **ChannelHandler**：

   - 实现具体的业务逻辑，处理 I/O 事件（如数据读取、写入）。
   - Netty 允许开发者自定义 `ChannelHandler`，灵活实现业务需求。

5. **EventLoop**：

   - 每个 `EventLoop` 是一个单线程，运行一个事件循环，负责监听和分发 `Channel` 的事件。
   - 通过 `Selector`（基于 Java NIO）实现多路复用，高效处理多个连接。

### Netty 的 Reactor 模式工作流程

1. **初始化**：
   - 创建 `Boss EventLoopGroup` 和 `Worker EventLoopGroup`。
   - `ServerBootstrap` 配置服务器，绑定端口，并指定 `Channel` 类型。
2. **连接处理**：
   - `Boss EventLoopGroup` 中的 `EventLoop` 监听 `ServerSocketChannel` 的 Accept 事件。
   - 当新连接到达时，`Boss EventLoop` 接受连接并创建一个新的 `SocketChannel`。
   - 新连接分配给 `Worker EventLoopGroup` 中的某个 `EventLoop`。
3. **事件处理**：
   - `Worker EventLoop` 监听分配的 `SocketChannel` 的 I/O 事件（如读、写）。
   - 当事件发生时，通过 `ChannelPipeline` 调用相应的 `ChannelHandler` 处理。
4. **业务逻辑**：
   - `ChannelHandler` 执行数据解码、业务处理、数据编码等操作。
   - 如果业务逻辑复杂，可通过 `EventExecutorGroup` 交给工作线程池处理，避免阻塞 `EventLoop`。

**示例代码**：

```java
// Netty 服务器示例
EventLoopGroup bossGroup = new NioEventLoopGroup(1); // 主 Reactor
EventLoopGroup workerGroup = new NioEventLoopGroup(); // 子 Reactor
try {
    ServerBootstrap b = new ServerBootstrap();
    b.group(bossGroup, workerGroup)
     .channel(NioServerSocketChannel.class)
     .childHandler(new ChannelInitializer<SocketChannel>() {
         @Override
         protected void initChannel(SocketChannel ch) {
             ch.pipeline().addLast(new MyHandler()); // 自定义处理程序
         }
     });
    b.bind(8080).sync().channel().closeFuture().sync();
} finally {
    bossGroup.shutdownGracefully();
    workerGroup.shutdownGracefully();
}
```

### Netty 如何体现 Reactor 模式的优势

- **高效的事件分发**：`EventLoop` 使用 Java NIO 的 `Selector`，实现非阻塞 I/O 和事件多路复用。
- **线程模型优化**：`Boss` 和 `Worker` 分离，主 Reactor 只处理连接，子 Reactor 专注于 I/O 事件，业务逻辑可进一步异步化。
- **模块化设计**：`ChannelPipeline` 和 `ChannelHandler` 提供灵活的事件处理链，开发者可专注于业务逻辑。
- **高可扩展性**：通过调整 `EventLoopGroup` 的线程数，Netty 可适配不同规模的并发需求。

**思考题 5**：在 Netty 中，为什么 `Boss EventLoopGroup` 通常只需要 1 个线程，而 `Worker EventLoopGroup` 需要多个线程？

## 总结

Reactor 模式通过事件驱动和非阻塞 I/O，解决了传统阻塞式网络编程的性能瓶颈。单线程 Reactor 简单高效，适合轻量级场景；多线程 Reactor 通过任务分离和线程池，适配高并发场景。Netty 基于 Reactor 模式，通过 `EventLoopGroup`、`Channel` 和 `ChannelPipeline` 等组件，实现了高性能、可扩展的网络框架。

希望这篇文章让你对 Reactor 模式及其在 Netty 中的应用有了清晰的理解！如果有更多问题，欢迎留言讨论。

**思考题答案**（供参考）：

1. 10,000 个连接 × 1MB = 10GB 内存。局限性：线程切换开销大，内存占用高，扩展性差。ulimit -n 10000
2. 阻塞 I/O 每个连接独占线程，资源浪费；非阻塞 I/O 通过事件驱动，复用线程，效率更高。
3. CPU 密集型任务会阻塞事件循环，导致延迟。改进：引入多线程或异步任务处理。
4. 主 Reactor 专注连接分配，子 Reactor 处理 I/O 事件，分工明确以提高效率。
5. 连接建立（Accept）频率较低，单线程足以；I/O 事件频繁，多个线程可并行处理。