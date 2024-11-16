package Handler;

import io.netty.channel.ChannelHandlerContext;
import io.netty.channel.SimpleChannelInboundHandler;

public class ChatClientHandler extends SimpleChannelInboundHandler<String> {
    @Override
    protected void channelRead0(ChannelHandlerContext ctx, String msg) {
        // 客户端收到 服务端消息，去掉尾部回车 后，打印到屏幕
        System.out.println(msg.trim());
    }
}
