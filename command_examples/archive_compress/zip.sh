#!/bin/bash

# desc:zip是一个打包和压缩工具，相当于tar+gzip的功能，这是zip区别于gzip最大地方

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
mkdir demo_dir
cp demo_file demo_dir/demo_file1
cp demo_file demo_dir/demo_file2
cp demo_file demo_dir/demo_file3
cp demo_file demo_file1
cp demo_file demo_file2
cp demo_file demo_file3
cp demo_file demo.sh
cp demo_file demo1.sh

# clean all when exit
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

# begin examples

# 将文件demo_file demo_file1和目录demo_dir一起打包压缩成demo.zip，原来的文件仍然存在，-r表示会递归目录进行压缩
zip -r demo.zip demo_file demo_file1 demo_dir

# 查看zip压缩包中的文件
unzip -lv demo.zip

# 找出本目录下的shell文件并全部压缩为shell.zip. -@表示从标准输入接收文件列表
find . -name "*.sh" -print | zip shell -@

# 从标准输入接收压缩数据，生成shell.zip文件
cat demo*.sh | zip shell -

# 将本目录压缩直接通过网络传输到备份中心，本地不生成zip文件
zip -r - . | ssh foo@backuphost.com "cat > backup.zip"
zip -r - . | ssh foo@backuphost.com dd of=backup.zip

# 除了demo_file3外，其余文件都压缩
zip -r demo_file.zip . -x demo_file3

# 将压缩包中的demo_file1删除
zip -d demo_file.zip demo_file1

# 将压缩包的文件解压到特定目录下去
unzip demo_file.zip -d $sandbox_dir/testdir

# end examples
ls -lR $sandbox_dir
clean_all
