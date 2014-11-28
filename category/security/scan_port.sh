#!/bin/bash

# name
# 端口扫描
#
# desc
# 扫描服务器上监听的端口，包括TCP和UDP
#
# LANG
# bash
#
# OS
# CentOS RHEL Fedoral Ubuntu Debian
#
# sudo
# no

set -e

[ -x /bin/nc ] && NC=/bin/nc
[ -x /usr/bin/nc ] && NC=/usr/bin/nc
[ -z "$NC" ] && error "nc must be installed."

echo "> scanning ports from 1 to 65535 on all interfaces, may take one minute ..."
IPS=$(/sbin/ip ad|grep -P 'inet \d+\.\d+\.\d+\.\d+'|cut -f1 -d/|awk '{print $2}')

# tcp port scan
for ip in $IPS; do
  $NC -znv $ip 1-65535 2>&1|grep -E "succeeded|open"
done

echo

# udp port scan
for ip in $IPS; do
  $NC -znuv $ip 1-65535 2>&1|grep -E "succeeded|open"
done

