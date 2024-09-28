package ClientAndServer;

import Handler.ChatServerHandler;
import io.netty.bootstrap.ServerBootstrap;
import io.netty.channel.ChannelFuture;
import io.netty.channel.ChannelInitializer;
import io.netty.channel.ChannelPipeline;
import io.netty.channel.nio.NioEventLoopGroup;
import io.netty.channel.socket.SocketChannel;
import io.netty.channel.socket.nio.NioServerSocketChannel;
import io.netty.handler.codec.string.StringDecoder;
import io.netty.handler.codec.string.StringEncoder;

public class ChatServer {
    public static void main(String[] args) throws InterruptedException {
        /*
        *
1. Boss 线程
功能: Boss 线程负责监听和接收新的客户端连接请求。它通常会在一个单独的线程中运行。
任务:
绑定服务器端口。
接受新的连接，并为每个连接创建一个新的 Channel。
将新连接分配给 Worker 线程进行后续处理。
2. Worker 线程
功能: Worker 线程负责处理已建立连接的数据读写操作。
任务:
读取来自客户端的数据。
处理业务逻辑。
写入响应数据回客户端。
        *

        * */
        NioEventLoopGroup bossGroup = new NioEventLoopGroup(1);
        NioEventLoopGroup workerGroup = new NioEventLoopGroup();
        try {
            ServerBootstrap serverBootstrap = new ServerBootstrap();
            serverBootstrap.group(bossGroup, workerGroup)
                    .channel(NioServerSocketChannel.class)
                    .childHandler(new ChannelInitializer<SocketChannel>() {
                        @Override
                        protected void initChannel(SocketChannel ch) throws Exception {
                            ChannelPipeline pipeline = ch.pipeline();

                            // 加入 编解码器
                            pipeline.addLast("decoder", new StringDecoder());
                            pipeline.addLast("encoder", new StringEncoder());

                            // 加入 自己的业务处理
                            pipeline.addLast(new ChatServerHandler());
                        }
                    });
            System.out.println("聊天室启动...");
            ChannelFuture channelFuture = serverBootstrap.bind(9000).sync();
            channelFuture.channel().closeFuture().sync();
            /*
            *
在 Netty 中，ChannelFuture 是一个重要的概念，主要用于表示与 Channel 相关的异步操作的结果。它不仅可以用来获取操作的状态，还可以通过监听器进行回调处理。以下是关于 ChannelFuture 的详细解释：
1. 概述
定义: ChannelFuture 是对某个 Channel 操作的异步结果的表示，通常与 Channel 的创建、绑定、连接和关闭等操作关联。
异步编程: Netty 是一个异步框架，许多操作（例如绑定、连接、写入数据）都是非阻塞的，ChannelFuture 提供了一种方式来处理这些异步操作的完成状态。
2. 常用方法
isDone(): 检查操作是否已完成。
isSuccess(): 检查操作是否成功。
get(): 阻塞当前线程直到操作完成，并返回结果。
cause(): 获取导致操作失败的异常（如果有的话）。
channel(): 获取与此 ChannelFuture 相关联的 Channel 实例。
sync(): 阻塞当前线程，直到操作完成。如果操作失败，会抛出异常。
            *
            *
            *
            * */
        } finally {
            bossGroup.shutdownGracefully();
            workerGroup.shutdownGracefully();
        }
    }
}
