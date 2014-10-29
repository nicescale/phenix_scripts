#!/bin/bash

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

function get_release() {
  [ -x /usr/bin/lsb_release ] && VERSION=$(lsb_release -r -s)
  [ -z "$VERSION" ] && VERSION=$(awk '/DISTRIB_RELEASE=/' /etc/*-release | sed 's/DISTRIB_RELEASE=//')
  [ -z "$VERSION" ] && VERSION=$(awk '/VERSION_ID=/' /etc/*-release | sed 's/VERSION_ID=//')
  [ -z "$VERSION" ] && VERSION=$(cat /etc/*-release|rev|cut -f1 -d ' '|rev|grep -P '^\d')
  if echo $VERSION|grep -q -P '"\d+.*"'; then
    echo $VERSION|tr -d '"'
  else
    echo $VERSION
  fi
}

function die() {
  echo $*
  exit 1
}

DIST=`distrib_id`
RELEASE=`get_release`

case $DIST in
  Ubuntu)
    [ $RELEASE != "14.04" ] && die "Only support Ubuntu 14.04"
    apt-get update
    apt-get -y install lxc-docker
    ps ax|grep docke[r] || service docker start
    ;;
  CentOS)
    if echo $RELEASE|grep ^6; then
      rpm -i http://mirrors.hustunique.com/epel/6/i386/epel-release-6-8.noarch.rpm
      yum -y install docker-io
      service docker start
    elif echo $RELEASE|grep ^7; then
      yum -y install docker
      systemctl start docker.service
    else
      die "CentOS $RELEASE not support yet."
    fi
    ;;
  *)
    die "OS($DIST) not supported yet"
esac

docker ps -q || die "docker NOT run"

TOPDIR=/data/nicescale
mkdir -p $TOPDIR/{db,keys,jobworker,public_scripts,logs} 2>/dev/null || true 
PRIVKEY_PATH=$TOPDIR/jobworker/privkey.pem
PUBKEY_PATH=$TOPDIR/keys/pubkey.pem

if [ ! -f $PUBKEY_PATH -o ! -f $PRIVKEY_PATH ]; then  
  openssl genrsa -out $PRIVKEY_PATH 2048
  openssl rsa -in $PRIVKEY_PATH -outform PEM -pubout -out $PUBKEY_PATH
fi

docker pull nicescale/nicescale-enterprise

ocker run -d --name=ns-enterprise -v $TOPDIR:/data -v $TOPDIR/logs:/logs -p 80:80 nicescale/nicescale-enterprise
