#!/bin/bash

# rpm是RedHat系Linux下的包管理工具，类似Debian下的dpkg

# begin examples

# 为CentOS6添加EPEL软件包源
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm

# 安装软件包
rpm -ivh pakcage.rpm

# 删除一个软件包
rpm -e package

# 找出某个文件属于哪个包
rpm -qf /path/to/file

# 查看某个软件包将文件安装到哪里去了
rpm -ql package

# 查找一个rpm文件里有哪些文件列表
rpm -qpl package.rpm

# 列出当前系统已安装的所有软件包
rpm -qa

# end examples
