#!/bin/bash

# free 是查看Linux内存使用的命令
free

      total   used   free  shared  buffers  cached
Mem:  1017896=929284+88612  30352    91564  317480
      总内存 = 已用 + 空闲    |        |       |
-/+ buf/cach: 520240 497656   |        |       +- 从磁盘读出的数据用于后面重复使用
                |      |      |        +--------- 尚未写入磁盘的buffer
                |      |      +------------------ 多个进程共享的内存
                |      +-= free+buffers+cached -- 从程序角度还可使用的内存大小
                +--------= used-buffers-cached -- 从程序角度已经使用掉的内存
Swap: 1048572=179188+869384
      总交换 = 已用 + 空闲

