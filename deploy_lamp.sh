#!/bin/bash

### script attribute
# lang: bash
# name: 部署Lamp
# desc: 部署一个all_in_one的Lamp环境, Apache+MySql+PHP，支持CentOS/Redhat/Debian/Ubuntu

set -e

# Returns one of Debian, Ubuntu, RHEL, CentOS, Fedora, Archlinux, SLES, Gentoo ...
function distrib_id() {
  if [ -x /usr/bin/lsb_release ]; then
    lsb_release --id --short
  elif [ -f /etc/debian_version ]; then
    echo Debian
  elif [ -f /etc/fedora-release ]; then
    echo Fedora
  elif [ -f /etc/arch-release ]; then
    echo Archlinux
  elif [ -f /etc/gentoo-release ]; then
    echo Gentoo
  elif [ -f /etc/redhat-release ]; then
    release=`cat /etc/redhat-release`
    if echo $release|grep -q '^Red Hat Enterprise Linux'; then
      echo RHEL
    elif echo $release|grep -q '^CentOS'; then
      echo CentOS
    elif echo $release|grep -q '^Scientific Linux'; then
      echo SLES
    else
      echo Unknown
    fi
  else
    echo Unknown
  fi
}

DIST=`distrib_id`
case $DIST in
  Ubuntu|Debian)
    apt-get update
    apt-get -y install apache2 mysql-server php5
  ;;
  Fedora|CentOS)
    yum -y install apache2 mysql-server php5
  ;;
  *)
    echo not supported yet
esac

exit 0
