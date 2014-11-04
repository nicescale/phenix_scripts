#!/bin/bash

# kill是一个信号发送命令，由于默认发送TERM信号杀死进程，所以命名为kill

# begin examples

# 终止所有nginx进程，默认为Term信号
ps ax | grep ngin[x] | cut -c1-5 | xargs kill

# 友好重启某个服务，一般是HUP信号
kill -HUP pid

# 显示支持的信号类型
kill -l

# 向某个进程发送指定信号
kill -9 pid
kill -SIGKILL pid
kill -KILL pid

# 杀死所有你有权限杀死的进程，谨慎尝试
kill -9 -1

# 查看11号信号的英文名称
kill -l 11

# end examples
