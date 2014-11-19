#!/bin/sh

# desc
# 该脚本是给apache的vhost添加别名，这样可以通过多个域名访问该网站。
# 
# env
# SERVER_NAME:指定增加哪个vhost的别名
# SERVER_ALIAS:别名，可指定多个，空格分隔

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

sed -i "/ServerName/a \  ServerAlias $SERVER_ALIAS" $CONF_FILE

echo "> ServerAlias $SERVER_ALIAS added to vhost $SERVER_NAME successfully."

