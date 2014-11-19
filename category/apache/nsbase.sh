#!/bin/sh

distrib_id() {
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
error() {
  echo $* >&2
  return 1
}

DIST=`distrib_id`

pack_install() {
  pack=$1
  case $DIST in
    Debian|Ubuntu)
    ;;
    Fedora|CentOS|SLES|RHEL)
    ;;
    *)
  esac
}

case $DIST in
  Debian|Ubuntu)
    pack_updateindex='apt-get update'
    pack_install='apt-get -y install'
    pack_remove='apt-get -y remove'
  ;;
  Fedora|CentOS|SLES|RHEL)
    pack_updateindex='yum updateinfo'
    pack_install='yum -y install'
    pack_remove='yum -y remove'
  ;;
  Archlinux)
  ;;
  Gentoo)
  ;;
  Slackware)
  ;;
  Suse)
  ;;
  *)
esac

