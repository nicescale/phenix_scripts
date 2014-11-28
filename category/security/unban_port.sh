#!/bin/bash

# name
# 解封端口
#
# desc
# 允许端口对外开放
#
# lang
# bash
#
# env
# PORTS: 端口，可多个，逗号分隔

[ -z "$PORTS" ] && error "> must supply envirement PORTS."

/sbin/iptables-save > /tmp/ipt.txt

for p in $(echo $PORTS | tr ',' ' '); do
  cat /tmp/ipt.txt|grep "\-A INPUT"|grep "dport $p"|sed -n 's!^-A!/sbin/iptables -D!p'|/bin/sh
done

echo "> Unban $PORTS successfully."

/sbin/iptables -L INPUT -n

/bin/rm /tmp/ipt.txt
