#!/bin/bash

# apt-get是Debian系Linux下的软件包依赖管理工具
# 环境变量 DEBIAN_FRONTEND=noninteractive 控制apt-get命令是否进入交互式

# 从远端更新本地包的列表和索引
apt-get update

# 升级现有的所有软件包，但不安装新的软件
apt-get upgrade

# 整个发行版本升级，会安装必要的新的软件
apt-get -y dist-upgrade

# 安装一个或多个软件包
apt-get -y install package1 package2 ...

# 只下载不安装
apt-get download some-pkg

# Show apt-get installed packages.
grep 'install ' /var/log/dpkg.log
dpkg -l
