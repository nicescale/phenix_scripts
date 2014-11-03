#!/bin/bash

# dmesg命令用来显示内核ring buffer中的消息。从系统启动、到运行过程中各种内核级别的日志都可以从dmesg查看

set -e

# 确认某个驱动内核是否载入
dmesg | grep drivername

# 确认某个设备内核是否识别
dmesg | grep eth0
dmesg | grep sdb
dmesg | grep usb
dmesg | grep dma

# 只查看dmesg的最前面20行内容
dmesg | head -20

# 只查看dmesg的最后20行输出内容
dmesg | tail -20
