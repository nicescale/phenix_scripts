#!/bin/bash

set -e

#initialize testing envirement
sandbox_dir=/tmp/sandbox_$RANDOM
[ -d $sandbox_dir ] || mkdir $sandbox_dir
cd $sandbox_dir 
touch a.txt b.txt B.txt
ln -s b.txt bl.txt

#clean all when exit
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

#begin examples

#根据文件名查找文件
find ./  -name "a.txt"
find ./ -name "*.txt"
find ./ -iname "*.TxT"
find ./ -regex "b+ ?\.txt" -regextype posix-extended

#根据文件类型查找文件，支持的文件类型有：
#b 块设备
#c 字符设备
#d 目录
#p 管道
#f 普通文件
#l 符号链接
#s socket文件
find . -type f # 找出当前目录下所有的普通文件
find . -type l # 找出当前目录下所有的符号链接

#根据文件大小查找文件，支持的单位有：
#b block, 512字节
#c character, 1 byte
#k KB, 1024 字节
#w 2 bytes
#M MB
#G GB
find . -size +1k -a -size -10k # 找出所有大小在1K和10K之间的文件
find . -size +1M -o -size -1k # 找出所有大于1M或小于1K的文件

# 根据文件属主查找文件，支持user/group、uid/gid、nouser/nogroup选项
# 找出所有属主是nobody的文件
find . -user nobody  
## 找出所有uid在80和500之间的文件
find . -uid +80 -uid -500 
##  找出系统中非root属主的文件
find . -nouser root  

# 根据文件权限查找文件
find . -perm 555  ## 找出系统中权限为555的所有文件
find . -perm u+r,u+x,g+r,g+x,a+r,a+x  ## see above
find . -perm -222  ## 找出系统中所有在o/g/a为可写的文件，o/g/a三位必须同时满足
find . -perm -u+w,g+w,a+w  ## see above
find . -perm /222  ## 找出系统中对任一用户都可写的文件，o/g/a三位满足其一即可
find . -perm /u+w,g+w,a+w ## see above
find . -perm /220  ## 同上，但对a位不做要求
find . -perm /u+w,g+w  ## see above

# 根据文件时间查找文件
# amin cmin mmin atime ctime mtime anewer cnewer newer
find . -atime +7 -atime 14  ##  找出系统中7天前14天内被访问过的文件
find . -daystart -type f -mtime 1  ## 找出昨天被修改的文件，将时间计算点设成今天的0点,daystart是作为option出现

# 根据文件连接查找文件
find . -samefile /tmp/a.txt  ## find links related to /tmp/a.txt
find . -inum 255    ## inode number
find . -links 255   ## hard links number

# 找出所有权限是777的文本文件
find . -name *.txt -a -perm 777

# 找出系统中所有的备份文件
find . -name *.bak -o -name *.org

# 找出是属主root用户的非regular file的文件
find . ! -type f -a -u root

# 找出others可写的regular files，并打印到stdout,每个文件后带有newline
find . -type f -perm /002 -print

## 同上，但将文件名打印到了文件中
find . -type f -perm /002 -fprint /tmp/find.log  

## 找出小于4k的文件，并打印到stdout,但文件名后无newline
find . -size -4k -print0 

## 同上，但将文件名打印到文件
find . -size -4k -fprint0 /tmp/find1.log 

# ls动作类似于命令ls -l，只是ls动作多打印了两列：inode number 和 block numbers(k)
find . -perm /u+r -ls
## 同上，只是打印到文件
find . -perm /u+r -fls /tmp/fls.log
## 按格式打印
find . -perm /u-x -type d -printf ...?
## 换成exec也行，但没有execdir安全，如果当前目录在$PATH中，execdir会拒绝
find . -name '*.h' -execdir diff -u '{}' /tmp/master ';'
## 同时对多个文件执行同一命令，可大大提高速度
find . -perm /u+w -execdir stat '{}' '+'
##同上，但文件名的处理并不安全
find . -perm /u+w | xargs stat
## 同上，安全
find . -perm /u+w -print0 | xargs stat
## 交互式的处理文件
find . -perm /u+w -okdir stat '{}' ';'
## 交互式处理文件
find . -perm /u+w -print | xargs --interactive stat

# 递归删除当前目录下所有日志文件
find . -name '*.log' -delete

#(daystart,xdev/mount,depth/d,maxdepth,mindepth,noignore_readdir_race/ignore_readdir_race,regextype,follow)
## 找出所有指向gnu.linux文件的hard links，xdev表示不夸文件系统
find . -xdev -samefile /tmp/gnu.linux

## 深度优先，最底层的文件先行处理
find . -depth -name *.txt -delete

## find files owned by www between 2 and 4 levels
find . -maxdepth 4 -mindepth 2 -user www

#end examples
clean_all
# To find files by case-insensitive extension (ex: .jpg, .JPG, .jpG):
find . -iname "*.jpg"

# To find directories:
find . -type d

# To find files:
find . -type f

# To find files by octal permission:
find . -type f -perm 777

# To find files with setuid bit set:
find . -xdev \( -perm -4000 \) -type f -print0 | xargs -0 ls -l

# To find files with extension '.txt' and remove them:
find ./path/ -name '*.txt' -exec rm '{}' \;

# To find files with extension '.txt' and look for a string into them:
find ./path/ -name '*.txt' | xargs grep 'string'

# To find files with size bigger than 5 Mb and sort them by size:
find . -size +5M -type f -print0 | xargs -0 ls -Ssh | sort -z

# To find files bigger thank 2 MB and list them:
find . -type f -size +20000k -exec ls -lh {} \; | awk '{ print $9 ": " $5 }'

# To find files modified more than 7 days ago and list file information
find . -type f -mtime +7d -ls

# To find symlinks owned by a user and list file information
find . -type l --user=username -ls

# To search for and delete empty directories
find . -type d -empty -exec rmdir {} \;

# To search for directories named build at a max depth of 2 directories
find . -maxdepth 2 -name build -type d

# To search all files who are not in .git directory
find . ! -iwholename '*.git*' -type f

# Find all files that have the same node (hard link) as MY_FILE_HERE
find . -type f -samefile MY_FILE_HERE 2>/dev/null
