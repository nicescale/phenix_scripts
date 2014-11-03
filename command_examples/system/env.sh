#!/bin/bash

# env命令是用来列出当前系统的环境变量，或控制程序启动的环境变量

# begin examples

# 设定一个或多个环境变量来启动程序
env ENV1=v1 ENV2=v2 some-command
ENV1=v1 ENV2=v2 some-command

# 忽略所有环境变量除了显式指定的外
env -i ENV1=V1 some-command

# end examples
