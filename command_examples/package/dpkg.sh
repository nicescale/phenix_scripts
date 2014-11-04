#!/bin/bash

# dpkg是debian系Linux下的包管理工具，是apt-get的底层包管理工具

# begin examples

# 安装一个本地.deb包
dpkg -i package.deb

# 列出本地已经安装的包
dpkg -l

# 列出某个软件包所包含的文件路径
dpkg -L package

# 找出某个文件或命令属于哪个包
dpkg -S `which dpkg`

# 删除某个软件包,选项P彻底删除，会删除相关配置文件.
dpkg -r package
dpkg -P package

# 重新配置某个软件包，往往是交互式的配置
dpkg --configure package

# end examples
