#!/bin/bash

# 用户可快速添加swap空间

SWAPPATH=$1
SWAPSIZE=$2

dd if=/dev/zero of=$SWAPPATH bs="$SWAPSIZE"m count=1

ls -lh $SWAPPATH 

mkswap $SWAPPATH
swapon $SWAPPATH

swapon -s
