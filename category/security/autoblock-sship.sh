#!/bin/bash

#自动屏蔽密码尝试的ip的脚本
#!/bin/sh
#### 获取前 1 分钟内的 secure 记录，统计 ssh 认证失败的 IP 和其 失败次数
#SCANNER=`grep "$(date -d -1min +%Y-%m-%dT%H:%M)" /var/log/secure|awk '/Failed/{print $(NF-3)}'|awk -F":" '{print $NF}'|grep -v from|sort|uniq -c|awk '{print $1"="$2;}'`
`more /var/log/secure|awk '/Failed/{print $(NF-3)}'|awk -F":" '{print $NF}'|grep -v from|sort|uniq -c|awk '{print $1"="$2;}' > /var/log/badips.txt`
filepath="/var/log/badips.txt"
while read LINE
#for i in `cat /var/log/badips.txt`
do
    # 取认证失败次数
    NUM=`echo $LINE|awk -F= '{print $1}'`
        # 取其 IP 地址
        IP=`echo $LINE|awk -F= '{print $2}'`
        # 若其在失败次数超过 2 次且之前没有被阻断过，那么添加一条策略将其阻断，并记录日志
        added=`/sbin/iptables -vnL INPUT|grep $IP|wc -l`
        if [ $NUM -gt 20 ] && [ $added -eq 0 ]
        then
                `/sbin/iptables -I INPUT 2 -s $IP -m state --state NEW,RELATED,ESTABLISHED -j DROP`
                echo "`date` $IP($NUM)" >> /var/log/blockip.log
        fi
done < $filepath
