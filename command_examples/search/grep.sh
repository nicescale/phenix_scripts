#!/bin/bash

set -e

#初始化样例测试环境
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

#清理测试遗留
clean_all() {
  [ -d $sandbox_dir ] && rm -fr $sandbox_dir
}
trap 'clean_all' ERR

#begin examples

#Search for a given string in a file (case in-sensitive search).
grep -i "the" demo_file

#Print the matched line, along with the 3 lines after it.
grep -A 3 -i "empty" demo_file

#Search for a given string in all files recursively
grep -r "last" *

#if you can use use regular expression effectively. In the following example, it searches for all the pattern that starts with “lines” and ends with “empty” with anything in-between. i.e To search “lines[anything in-between]empty” in the demo_file.
grep "lines.*empty" demo_file

#Checking for full words, not for sub-strings using grep -w
grep -iw "is" demo_file

#Displaying lines before/after/around the match using grep -A, -B and -C

#Searching in all files recursively using grep -r
grep -r "ramesh" *

#Invert match using grep -v
grep -v "go" demo_text
grep -v -e "case" -e "CASE" demo_text

#When you want to count that how many lines matches the given pattern/string
grep -c "go" demo_text

#Display only the file names which matches the given pattern
grep -l this demo_*

#To show the line number of file with the line matched
grep -n "go" demo_text

#end examples
clean_all
# Basic:
grep pattern file

# case nonsensitive research:
grep -i pattern file

# Recursively grep for string <pattern> in folder:
grep -R pattern folder

# Getting pattern from file (one by line):
grep -f pattern_file file

# Find lines NOT containing pattern
grep -v pattern file

# You can grep with regular expressions
grep "^00" file  #Match lines starting with 00
grep -E "[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}" file  #Find IP add

# Find all files who contain {pattern} in the directory {directory}.
# This will show: "file:line my research"
grep -rnw 'directory' -e "pattern"

# Exclude grep from your grepped output of ps.
# Add [] to the first letter. Ex: sshd -> [s]shd
ps aux | grep '[h]ttpd'

# Colour in red {bash} and keep all other lines
ps aux | grep -E --color 'bash|$'
