#!/bin/sh

HOST=`/sbin/ip addr show | awk '/inet / {print $2}'|cut -f 1 -d '/'|grep -v 127.0.0.1|grep -v 192.168|head -1`

NC=
APACHECTL=
MAIL_CONTENT=
RESTART=OK
LOCK=/dev/shm/httpderror
PORT=80

MAXCLIENTS=
NICESCALE_VER=
HTTPD_NUM_STAT_FILE=
WEB_TIMEOUT_STAT_FILE=
STATUS=0
STATUS1=0

require() {
        NC=`which nc 2>/dev/null`
        [ ! -x $NC ] && exit
	[ "$ROLE" = "unknown" ] && exit

	if [ "$ROLE" == "test" -o "$ROLE" == "test2" -o "$ROLE" == "wbtest" -o "$ROLE" == "3rdwbtest" ];then
		exit;
	fi

	#if [ "$ROLE" == "Web1" -o "$ROLE" == "test" -o "$ROLE" == "admin" ]; then
	if [ "$ROLE" == "Web1" -o "$ROLE" == "admin" ]; then
		NICESCALE_VER=1
		APACHECTL=/usr/local/nicescale/bin/apachectl
		MAXCLIENTS=`grep MaxClients /usr/local/nicescale/etc/httpd.conf|awk '{print $2}'|head -1`
                ERRLOG=/data1/apache/logs/error_log
	#elif [ "$ROLE" == "Web2" -o "$ROLE" == "test2" -o "$ROLE" == "admin2" ]; then
	elif [ "$ROLE" == "Web2" -o "$ROLE" == "admin2" -o "$ROLE" == "Varnish" ]; then
		NICESCALE_VER=2
		APACHECTL=/usr/local/nicescale/bin/apachectl
		MAXCLIENTS=`grep MaxClients /usr/local/nicescale/etc/httpd-vhost.conf|awk '{print $2}'|head -1`
    ERRLOG=/usr/local/nicescale/var/logs/error_log
	else
		exit
	fi

	if [ ! -f /data1/apache/htdocs/default/check -a ! -f /data1/www/htdocs/default/check ]; then
		exit
	fi
	[ -f /dev/shm/diskerror.* ] && exit
        test ! -d /var/log/mon_temp/ && mkdir -p /var/log/mon_temp/
        test ! -f /var/log/mon_temp/httpd_num.temp && echo 0 > /var/log/mon_temp/httpd_num.temp
	test ! -f /var/log/mon_temp/web_timeout.temp && echo 0 >/var/log/mon_temp/web_timeout.temp
	HTTPD_NUM_STAT_FILE="/var/log/mon_temp/httpd_num.temp"
        WEB_TIMEOUT_STAT_FILE="/var/log/mon_temp/web_timeout.temp"
}

apache_check_eac() {
        tail -n6 $ERRLOG |grep -q 'PHP crashed' && STATUS1=1
}

apache_check_apc() {
        tail -n10 $ERRLOG |grep -q 'apc-error' && return 1
        return 0
}

check_httpd_num() {
        HTTPD_NUM=`ps ax|grep httpd|grep -v grep|wc -l`
	HTTPD_LIMIT=`expr $MAXCLIENTS \* 1 / 2`
	[ "$HTTPD_LIMIT" -le 64 ] && HTTPD_LIMIT=64
	if [ "$HTTPD_NUM" -ge "$HTTPD_LIMIT" ]; then
             $APACHECTL restart
	     echo 1 > $HTTPD_NUM_STAT_FILE
             MAIL_CONTENT="Alert: Too many HTTPd Process: $HTTPD_NUM"
	     alert 
        else
	     if [ `cat $HTTPD_NUM_STAT_FILE` == 1 ];then
                echo 0 > $HTTPD_NUM_STAT_FILE
                alert 
             fi
        fi
}

do_repair() {
	#ulimit -c unlimited
	MAIL_CONTENT1="apache errorlog:
=====================================
"`tail -n 10 $ERRLOG`

	MAIL_CONTENT="
$MAIL_CONTENT1
"
       	$APACHECTL graceful 
	sleep 15
	if ! apache_is_normal; then
		ps ax | grep  "[h]ttpd" && killall -9 httpd
		sleep 5
		ipcs -s | grep www | perl -e 'while (<STDIN>) {@a=split(/\s+/); print `ipcrm sem $a[1]`}'
		$APACHECTL start || RESTART=FAILED
	fi
	if [ "$RESTART" == "FAILED" ]; then
	    echo 1 > $WEB_TIMEOUT_STAT_FILE
#	    /sbin/iptables -I INPUT -p tcp --dport 80 -j DROP
            MAIL_CONTENT=`echo -ne "Alert:Apache not response on [$HOST],restart faild!\n\n$MAIL_CONTENT"`
	    alert "$MAIL_CONTENT"
	fi
}

apache_is_normal() {
        /sbin/iptables -L -n|grep DROP|awk '$4 ~/0.0.0.0\/0/ {print}'|grep -w 80 > /dev/null
        if [ $? -eq 0 ];then
                return 0
        fi
	STATUS=1
	echo -en "GET /check HTTP/1.0\nHOST:127.0.0.1\n\n" | $NC -nv -w 7 127.0.0.1 $PORT | grep -q helloworld && STATUS=0
	echo -en "GET /check HTTP/1.0\nHOST:127.0.0.1\n\n" | $NC -nv -w 7 127.0.0.1 $PORT | grep -q helloworld && STATUS=0
}

apache_fd_check() {
	HTTPD_ROOT_PID=`ps aux|grep "http[d]"|grep root|awk '{print $2}'`
	[ -z "$HTTPD_ROOT_PID" ] && return
	FD_NUM=`ls /proc/$HTTPD_ROOT_PID/fd|wc -l`
	if [ "$FD_NUM" -gt 1024 ]; then
		$APACHECTL stop
		sleep 3
		$APACHECTL start
	fi
}

## main process #########
require
check_httpd_num
apache_fd_check
apache_is_normal
if [  $STATUS == 0 ];then
        if [ `cat $WEB_TIMEOUT_STAT_FILE` == 1 ];then
                echo 0 > $WEB_TIMEOUT_STAT_FILE
                alert 
        fi
else
        do_repair
fi

apache_check_eac 
if [  $STATUS1 == 0 ];then
        if [ `cat $WEB_TIMEOUT_STAT_FILE` == 1 ];then
                echo 0 > $WEB_TIMEOUT_STAT_FILE
                alert  
        fi
else
        do_repair
fi

#apache_check_apc || do_repair
if [ "$RESTART" == "FAILED" ]; then
	date +%s > $LOCK
else
	[ -f $LOCK ] && rm -f $LOCK
fi
exit

