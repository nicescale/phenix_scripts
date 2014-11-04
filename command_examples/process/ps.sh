
# ps是是unix下最基本的进程查看工具，下面的示例中，选项以-开头，说明是标准语法，否则属于BSD风格

# begin examples

# 显示系统中所有进程
ps -e
ps -ef
ps -eF
ps -ely
ps ax
ps aux

# 显示进程树
ps -ejH
ps axjf

# 显示线程信息
ps -eLf
ps axms

# 列出某个用户运行的进程
ps -au<foouser>

# 自定义显示的列
ps -eo pid,user,command
ps -eo pid,tid,class,rtprio,ni,pri,psr,pcpu,stat,wchan:14,comm
ps -eo pid,tt,user,fname,tmout,f,wchan
ps axo stat,euid,ruid,tty,tpgid,sess,pgrp,ppid,pid,pcpu,comm

# 查找httpd所有进程
ps aux | grep '[h]ttpd'

# 查看root用户运行的进程
ps -U root -u root u

# 查看僵尸进程
ps -ef | grep defunc[t]

# end examples
