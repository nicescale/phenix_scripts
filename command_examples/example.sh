#!/bin/bash

set -e

#initialize testing envirement
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
cp demo_file demo_file1

#clean all when exit
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

#begin examples

#Search for a given string in a file (case in-sensitive search).
grep -i "the" demo_file

#Display only the file names which matches the given pattern
grep -l this demo_*

#end examples
clean_all
