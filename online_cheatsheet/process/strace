# strace是跟踪系统调用的工具，经常用来做程序诊断

# 跟踪某个命令的系统调用输出
strace <command>

# 将strace记录输出到一个文件中
strace -o strace.out <command>

# 仅仅跟踪open()系统调用
strace -e trace=open <command>

# 跟踪和文件操作相关的系统调用
strace -e trace=file <command>

# 跟踪和进程管理相关的系统调用
strace -e trace=process <command>

# 同时跟踪子进程的系统调用
strace -f <command>

# 统计每个系统调用的次数，时间等
strace -c <command>

# 跟踪已经运行的进程
strace -p <pid>
