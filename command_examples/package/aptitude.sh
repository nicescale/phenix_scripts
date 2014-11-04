#!/bin/bash

# aptitude是Debian系Linux下的又一个包管理工具，和apt-get类似，会处理依赖关系

# begin examples

# 搜索某个软件包，会从描述里查找
aptitude search "whatever"

# 显示软件包的详细信息
aptitude show pkg(s)

# 安装某个软件包
aptitude install package

# 删除某个软件包
aptitude remove package

# 删除不需要的、系统过去自动安装的包
aptitude autoclean

# end examples
