#!/bin/sh

# env
# SERVER_NAME:网站的域名,比如www.example.com
# PORT:端口，默认为80
# SERVER_ALIAS:网站的别名,比如example.com也指向www.example.com,可指定多个,空格分隔

set -e

. ./nsbase.sh

[ -z "$PORT" ] && PORT=80

case $DIST in
  Debian|Ubuntu)
    CONF_DIR=/etc/apache2/sites-enabled
    DOCROOT=/var/www/$SERVER_NAME
    LOG_DIR=/var/log/apache2
    ;;
  Fedora|CentOS|RHEL)
    CONF_DIR=/etc/httpd/conf.d
    DOCROOT=/var/www/html/$SERVER_NAME
    LOG_DIR=/var/log/httpd
    ;;
  *)
    echo "$DIST not supported yet"
esac

if [ -z "$SERVER_ALIAS" ]; then
  serveralias=""
else
  serveralias="ServerAlias $SERVER_ALIAS"
fi

template="
<VirtualHost *:$PORT>
  ServerName $SERVER_NAME
  $serveralias
  DocumentRoot $DOCROOT
  <Directory $DOCROOT>
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    allow from all
  </Directory>

  LogLevel warn
  ErrorLog ${LOG_DIR}/${SERVER_NAME}-error.log
  CustomLog ${LOG_DIR}/${SERVER_NAME}-access.log combined
</VirtualHost>
"

[ -d $DOCROOT ] || mkdir -p $DOCROOT

cat <<EOF > $CONF_DIR/${SERVER_NAME}.conf
$template
EOF

echo "> Add vhost $SERVER_NAME successfully."

