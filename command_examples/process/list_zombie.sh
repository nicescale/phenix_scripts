#!/bin/bash

# name: 查看僵尸进程
# lang: bash
# comments: 列出Linux操作系统里的僵尸进程。僵尸进程是由于子进程退出时父进程没有wait导致。要清理僵尸进程，要么重启Linux，要么僵尸进程的父进程退出，让init(PID为1)作为父进程清理僵尸。

ps -ef | grep defunc[t]
