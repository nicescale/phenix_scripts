#!/bin/bash

# yum是RedHat系Linux下管理rpm软件包依赖关系的工具，类似apt-get

# begin examples

# 安装一个最新版本的软件包
yum install package

# 删除一个软件包
yum remove package

# 搜索软件包
yum search package

# 查找program文件属于哪个包
yum whatprovides /path/to/program

# 找出包的依赖关系
yum deplist package

# 显示包的详细信息
yum info package

# 列出当前在使用的yum仓库
yum repolist

# 下载src.rpm文件
yumdownloader --source <package name>

# end examples
