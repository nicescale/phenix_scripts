#!/bin/bash

ret=0

for i in `parted -l | grep Disk | sed 's/^.* \(.*\)GB.*$/\1/g'`
do
    if [ ${i%.*} -ge 1000 ]
    then
        ret=1
        break
    else
        continue
    fi
done

myip=`ifconfig | awk '/inet / {if(match($2,"addr")) {print substr($2,6)} else {print $2}}' | head -1`

if [ $ret -eq 1 ]
then
    alert "HWRaid Found"
fi
