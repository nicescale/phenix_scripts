#!/bin/bash

# tar是Linux下最常用的归档和备份工具，用来将多个文件合并为一个文件，往往和压缩命令同时使用

set -e

# initialize testing envirement
sandbox_dir=/tmp/sandbox_$RANDOM
[ -d $sandbox_dir ] || mkdir $sandbox_dir
cd $sandbox_dir 
cat <<EOF > demo_file
THIS LINE IS THE 1ST UPPER CASE LINE IN THIS FILE.
this line is the 1st lower case line in this file.
This Line Has All Its First Character Of The Word With Upper Case.

Two lines above this line is empty.
And this is the last line.
EOF
mkdir foo
cp demo_file foo/demo_file1
cp demo_file foo/demo_file2
cp demo_file foo/demo_file3
cp demo_file foo/demo.jpg
cp demo_file demo_file1
mkdir bar

# clean all when exit
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

# begin examples

# 创建一个无压缩的归档文件
tar -cvf foo.tar foo/

# 解包一个未压缩的归档文件, 选项D表示解包到指定目录，否则是解包到本目录下
tar -xvf foo.tar
tar -xvf foo.tar -C ./bar

# 创建一个压缩归档文件,选项z对应gzip, j对应bzip2, X对应compress
tar -czvf foo.tgz foo/
tar -cjvf foo.tar.bz2 foo/

# 解压一个压缩归档文件,选项z对应gzip,j对应bzip2,X对应compress
tar -xzvf foo.tgz
tar -xjvf foo.tar.bz2

# 列出压缩归档文件里的文件列表
tar -ztvf foo.tgz
tar -jtvf foo.tar.bz2

# 创建一个tgz压缩文件，但jpg,gif等文件除外
tar czvf foo.tgz --exclude=\*.{jpg,gif,png,wmv,flv,tar.gz,zip} foo/

# end examples
ls -lR $sandbox_dir
clean_all
