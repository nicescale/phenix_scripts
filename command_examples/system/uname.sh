#!/bin/bash

# uname是一个打印Unix操作系统信息的小工具，可以打印内核版本，cpu类型，hostname等各种信息

set -e

# 打印所有信息，包括操作系统，内核，cpu，hostname等
uname -a

# 打印short hostname，等同于hostname -s
uname -n

# 打印内核版本
uname -r

# 打印更详细的内核版本信息
uname -v

# 打印cpu指令集
uname -m

# 打印内核名, linux发行版输出为Linux，用来和其他*nix区分
uname -s

# 打印操作系统，在linux下一般输出为GNU/Linux
uname -o
