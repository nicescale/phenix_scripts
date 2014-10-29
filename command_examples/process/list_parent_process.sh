#!/bin/bash

# name: 查看某个进程的继承关系
# lang: bash
# comments: 了解某个进程的父进程、子进程等继承和被继承信息

PROCESS_NAME=$1

[ -z "$PROCESS_NAME" ] && PROCESS_NAME=init

PID=$(ps ax|grep -w $PROCESS_NAME|grep -v grep|cut -c1-5|uniq|sort -n)

OUTPUT=
for p in $PID; do
  echo $p
  a=$(pstree -ps $p)
  echo "$a"
  #OUTPUT="$OUTPUT\n$a"
done

#echo $OUTPUT|uniq|sort
