# Dockerfile是docker构建的基础，也是docker区别于其他容器的重要特征，正是有了Dockerfile，docker的自动化和可移植姓才成为可能

# FROM <image name>, 从一个基础镜像构建新的镜像
FROM ubuntu 

# MAINTAINER <author name>, 维护者信息
MAINTAINER William <wlj@nicescale.com>

# RUN <command>, 非交互式运行shell命令
RUN apt-get -y install nginx

# ADD <src> <dst>, 将外部文件拷贝到镜像里,src可以为url
ADD http://nicescale.com/  /data/nicescale.tgz

# CMD ["param1","param2"], docker运行时执行的命令，如果设置了ENTRYPOINT，则CMD将作为参数
CMD ["nginx"]

# EXPOSE <port>, 暴露哪些端口
EXPOSE 443 80

# ENTRYPOINT [‘executable’, ‘param1’,’param2’], 如果设置entrypoint，则docker运行时无法改变运行的命令
ENTRYPOINT [ "nginx" ]

# WORKDIR /path/to/workdir, 设置工作目录
WORKDIR /var/www

# ENV <key> <value>, 设置环境变量的kv
ENV TEST 1

# USER <uid>, 设置用户ID
USER nginx

# VULUME <dir>, 设置volume
VOLUME [‘/data’]

# Dockerfile最佳实践
A 尽量将一些常用的指令放到前面
B 构建镜像时命名tag应该用有意义的名字
C CMD和ENTRYPOINT尽量使用json数组方式
