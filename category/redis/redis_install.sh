#!/bin/bash

# name
#
# desc
#

set -e

. ./nsbase.sh

DIST=`distrib_id`

check_proc=`cat /proc/sys/vm/overcommit_memory`
check_swap=`cat /proc/sys/vm/swappiness`

if [ $check_proc -ne 1 ] ; then
  echo "vm.overcommit_memory=1" >> /etc/sysctl.conf
  /sbin/sysctl -p  /etc/sysctl.conf
fi

if [ $check_swap -ne 30 ] ; then
  echo "vm.swappiness=30" >> /etc/sysctl.conf
  /sbin/sysctl -p  /etc/sysctl.conf
fi

case $DIST in
  Ubuntu|Debian)
    pack_install redis-server
    service_restart redis-server
    ;;
  CentOS|RHEL|Fedora)
    pack_install redis
    service_restart redis
    ;;
  *)
    echo "> not supported."
esac

