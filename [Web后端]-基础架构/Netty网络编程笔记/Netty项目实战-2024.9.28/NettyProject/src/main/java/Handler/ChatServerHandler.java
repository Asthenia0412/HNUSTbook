package Handler;

import io.netty.channel.Channel;
import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;
import io.netty.channel.group.ChannelGroup;
import io.netty.channel.group.DefaultChannelGroup;
import io.netty.util.concurrent.GlobalEventExecutor;

import java.text.SimpleDateFormat;

/**
 * 用户上线时，打印  [ 客户端 ] xxx 上线了
 * 用户离线时，打印  [ 客户端 ] xxx 下线了
 * 用户发消息时
 *      如果不在自己的窗口，打印  [ 客户端 ] xxx 发送了消息 xxx
 *      如果在自己的窗口，打印   [ 自己 ] 发送了消息 xxx
 */
public class ChatServerHandler extends SimpleChannelInboundHandler<String> {

    //GlobalEventExecutor.INSTANCE 是全局的事件执行器，是一个单例，可以看做 所有客户端的集合
    private static ChannelGroup channelGroup = new DefaultChannelGroup(GlobalEventExecutor.INSTANCE);
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");


    /**
     * 功能：提示上线
     * 实现：当某个客户端上线时（channel 处于就绪状态），给其他所有客户端发送 该客户端上线消息
     */
    @Override
    public void channelActive(ChannelHandlerContext ctx) {
        Channel channel = ctx.channel();
        //将该客户加入聊天的信息推送给其它在线的客户端
        //该方法会将 channelGroup 中所有的 channel 遍历，并发送消息
        channelGroup.writeAndFlush("[ 客户端 ]" + channel.remoteAddress() + " 上线了 " + sdf.format(new
                java.util.Date()) + "\n");
        //将当前 channel 加入到 channelGroup
        channelGroup.add(channel);
        System.out.println("[ 客户端 ]" + ctx.channel().remoteAddress() + " 上线了 " + sdf.format(new java.util.Date()) + "\n");
    }

    /**
     * 功能：提示下线
     * 实现：当某个客户端下线时（channel 处于非就绪状态），给其他所有客户端发送 该客户端下线消息
     */
    @Override
    public void channelInactive(ChannelHandlerContext ctx) {
        Channel channel = ctx.channel();
        //将客户离开信息推送给当前在线的客户
        channelGroup.writeAndFlush("[ 客户端 ]" + channel.remoteAddress() + " 下线了" + "\n");
        System.out.println("[ 客户端 ]" + channel.remoteAddress() + " 下线了");
        System.out.println("剩余客户端个数 = " + channelGroup.size() + "\n");
    }

    //读取某个客户端数据，转发给其他客户端
    @Override
    protected void channelRead0(ChannelHandlerContext ctx, String msg) {
        //获取到当前 channel
        Channel channel = ctx.channel();
        //这时我们遍历 channelGroup, 根据不同的情况， 回送不同的消息
        channelGroup.forEach(ch -> {
            if (channel != ch) { //不是当前的 channel,转发消息
                ch.writeAndFlush("[ 客户端 ]" + channel.remoteAddress() + " 发送了消息：" + msg + "\n");
            } else {//回显自己发送的消息给自己
                ch.writeAndFlush("[ 自己 ]发送了消息：" + msg + "\n");
            }
        });
    }

    @Override
    public void exceptionCaught(ChannelHandlerContext ctx, Throwable cause) {
        //关闭通道
        ctx.close();
    }

}
