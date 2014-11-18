#!/bin/sh

MEMSIZE=`cat /proc/meminfo |grep MemTotal | awk '{print $2}'`
MEMSIZE=`expr $MEMSIZE / 1024`

if [ -x /usr/sbin/dmidecode ]; then
    VENDOR=`/usr/sbin/dmidecode|grep Vendor|cut -f 2 -d ':'| cut -c2-`
    PRODUCT=`/usr/sbin/dmidecode|grep 'Product Name'|head -1|cut -f 2 -d ':'| cut -c2-`
fi

if grep -q 'X86_HT=y' /boot/config-`uname -r`; then
    HT=y
else
    HT=n
fi

CPUNUM=`cat /proc/cpuinfo|grep processor|wc -l`
if [ "$HT" = 'y' ]; then
    CPUNUM=`expr $CPUNUM / 2`
fi

CPUFREQ=`cat /proc/cpuinfo |grep "cpu MHz"|head -1|cut -f2 -d ':'|cut -c2-`

DISKNUM=`/sbin/fdisk -l|grep Disk|wc -l`

DISKSIZE=0
for ds in `/sbin/fdisk -l|grep Disk|cut -d ' ' -f5`; do
    DISKSIZE=`expr $ds + $DISKSIZE`
done

DISKSIZE=`expr $DISKSIZE / 1024`
DISKSIZE=`expr $DISKSIZE / 1024`
DISKSIZE=`expr $DISKSIZE / 1024`

conffile=/etc/hw.ini
echo -ne > /etc/hw.ini
echo "MEMSIZE='$MEMSIZE'" >> $conffile
echo "VERDOR='$VENDOR'" >> $conffile
echo "PRODUCT='$PRODUCT'" >> $conffile
echo "HT='$HT'" >> $conffile
echo "CPUNUM='$CPUNUM'" >> $conffile
echo "CPUFREQ='$CPUFREQ'" >> $conffile
echo "DISKNUM='$DISKNUM'" >> $conffile
echo "DISKSIZE='$DISKSIZE'" >> $conffile

chmod 644 $conffile

