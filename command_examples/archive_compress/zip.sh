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

# clean all when exit
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

# begin examples

# 将文件demo_file demo_file1和目录demo_dir一起打包压缩成demo.zip，原来的文件仍然存在，-r表示会递归目录进行压缩
zip -r demo.zip demo_file demo_file1 demo_dir

exit
# 将文件添加到压缩文件中去
zip demo.zip demo_file2 demo_file3

# 递归压缩一个目录下所有文件，且会覆盖里面的文件为filename.gz
gzip -r demo_dir

# 解压文件demo_file.gz,并替代原来的压缩文件为demo_file
gzip -d demo_file.gz

# 解压文件demo_file1.gz，但不覆盖原来的压缩文件
gzip -d -c demo_file1.gz > demo_file2
zcat demo_file1.gz > demo_file3

# end examples
ls -lR $sandbox_dir
clean_all
