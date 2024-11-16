# 使用官方的 OpenJDK 镜像作为基础镜像
FROM openjdk:11-jre-slim

# 设置环境变量
ENV ES_HOME=/usr/share/elasticsearch
ENV PATH=$ES_HOME/bin:$PATH

# 创建 Elasticsearch 安装目录
RUN mkdir -p $ES_HOME

# 将解压后的 Elasticsearch 文件复制到容器中
COPY elasticsearch-7.12.1 $ES_HOME

# 暴露 Elasticsearch 默认端口
EXPOSE 9200 9300

# 设置容器启动时执行的命令
CMD ["elasticsearch"]
