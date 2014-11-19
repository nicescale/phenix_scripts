#!/bin/sh

# desc
# 查看某个域名的vhost配置
# 
# env
# SERVER_NAME:一般是网站域名

set -e

. ./nsbase.sh

case $DIST in
  Debian|Ubuntu)
    CONF_FILE=/etc/apache2/sites-enabled/$SERVER_NAME.conf
    ;;
  Fedora|CentOS|RHEL)
    CONF_FILE=/etc/httpd/conf.d/$SERVER_NAME.conf
    ;;
  *)
    echo "$DIST not supported yet"
esac

[ -f $CONF_FILE ] || error "Vhost $SERVER_NAME not exist."

cat $CONF_FILE
