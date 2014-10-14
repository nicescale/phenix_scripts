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

DIST=`distrib_id`
RELEASE=`get_release`

case $DIST in
  Ubuntu|Debian)
    apt-get update
    DEBIAN_FRONTEND=noninteractive apt-get -y install apache2 mysql-server php5 php5-imagick \
            php5-gd php5-json php5-memcached php5-cli php5-curl php5-mysql
    update-rc.d mysql defaults
    update-rc.d apache2 defaults
    service apache2 start
    service mysql start
    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  ;;
  Fedora)
    yum -y install httpd mariadb-server mariadb php php-mysql php-pecl-memcache \
           php-pear-Net-Socket php-gd php-cli php-mbstring  php-mcrypt php-mhash
    systemctl enable httpd.service
    systemctl enable mariadb.service
    systemctl start httpd.service
    systemctl start mariadb.service
    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  ;;
  CentOS|RHEL|SLES)
    if echo $RELEASE|grep -qP '^7'; then
      yum -y install httpd mariadb-server mariadb php php-mysql php-pecl-memcache \
             php-pear-Net-Socket php-gd php-cli php-mbstring  php-mcrypt php-mhash
      systemctl enable httpd.service
      systemctl enable mariadb.service
      systemctl start httpd.service
      systemctl start mariadb.service
    else
      yum -y install httpd mysql-server php php-mysql php-pecl-memcache \
             php-pear-Net-Socket php-gd php-cli php-mbstring  php-mcrypt php-mhash
      chkconfig httpd on
      chkconfig mysqld on
      service httpd start
      service mysqld start
    fi
    echo "<?php phpinfo(); ?>" > /var/www/html/info.php
  ;;
  Archlinux)
    pacman -S --noconfirm  apache percona-server php php-apache
    set -i -e 's/LoadModule unique_id_module.*/#LoadModule unique_id_module modules/mod_unique_id.so/' /etc/httpd/conf/httpd.conf

    echo '<?php phpinfo(); ?>' > /srv/http/info.php
  ;;
  *)
    echo not supported yet
esac

exit 0
