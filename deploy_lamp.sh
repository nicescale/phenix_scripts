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
    DEBIAN_FRONTEND-noninteractive apt-get -y install apache2 mysql-server php5 php5-imagick \
            php5-gd php5-json php5-memcached php5-cli php5-curl php5-mysql
    mysql_install_db
    update-rc.d mysql defaults
    update-rc.d apache2 defaults
    service apache2 start
    service mysql start
    cat <<EOF > /var/www/html/info.php
<?php
phpinfo();
?>
EOF
    
  ;;
  Fedora|CentOS)
    if [ $release -eq '7' ] || $DIST -eq "Fedora"; then
      yum -y install httpd mariadb-server mariadb php php-mysql php-pecl-memcache \
             php-pear-Net-Socket php-gd php-cli php-mbstring  php-mcrypt php-mhash
      mysql_install_db
      systemctl enable httpd.service
      systemctl start httpd.service
      systemctl enable mariadb.service
      systemctl start mariadb.service
    else
      yum -y install httpd mysql-server php php-mysql php-pecl-memcache \
             php-pear-Net-Socket php-gd php-cli php-mbstring  php-mcrypt php-mhash
      mysql_install_db
      chkconfig mysqld on
      service mysqld start
    fi
    cat <<EOF > /var/www/html/info.php
<?php
phpinfo();
?>
EOF
    echo "> pecl install module "
    echo "> run curl http://127.0.0.1/info.php"
  ;;
  Archlinux)
    pacman -Syu
    pacman -Sy apache percona-server php php-apache
    set -i -e 's/LoadModule unique_id_module.*/#LoadModule unique_id_module modules/mod_unique_id.so/' /etc/httpd/conf/httpd.conf

    echo '<?php phpinfo(); ?>' > /srv/http/info.php
  ;;
  *)
    echo not supported yet
esac

exit 0
