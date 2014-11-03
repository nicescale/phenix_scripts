#!/bin/bash

set -e

# begin examples

# 列出当前操作系统已经挂载的文件系统
mount

# 挂载设备或Label或UUID到某个目录挂载点去
mount -o ext4 /dev/sda5 /mnt/sda5
mount -o ext4 -L BACKUP /mnt/backup
mount -o ext4 -U uuid /mnt/backup

# 挂载在/etc/fstab中定义好的挂载项
mount /mountpoint

# 重新挂载root文件系统，如果想只读挂载，使用ro选项
mount -o remount,rw /

# 将一个目录挂载到另一个路径下
mount --bind /origin/path /destination/path

# 考虑到安全，禁止某个文件系统下的文件具有可执行权限
mount -o noexec /dev/sda2 /data

# 避免频繁更新atime，一般用户日志分区
mount -o noatime -L LOG /var/log/www

# 挂载网络文件系统
mount -t nfs nfshost:/volume /nfs

# 卸载某个分区
umount /mountpoint

# 强行卸载
umount -L /mountpoint

# end examples
