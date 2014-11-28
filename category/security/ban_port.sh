#!/bin/bash

# name
# 封端口
#
# desc
# 将某些端口封禁，默认封禁所有来源ip
#
# lang
# bash
#
# env
# PORTS: 端口，可多个，逗号分隔

[ -z "$PORTS" ] && error "> must supply envirement PORTS."

/sbin/iptables-save > /tmp/ipt.txt

for p in $(echo $PORTS | tr ',' ' '); do
  cat /tmp/ipt.txt | grep "\-A INPUT" | grep "dport $p" | grep "DROP" | grep tcp ||
  /sbin/iptables -I INPUT -p tcp --dport $p -j DROP

  cat /tmp/ipt.txt | grep "\-A INPUT" | grep "dport $p" | grep "DROP" | grep udp ||
  /sbin/iptables -I INPUT -p udp --dport $p -j DROP
done

echo "> Ban $PORTS successfully."

/bin/rm /tmp/ipt.txt
