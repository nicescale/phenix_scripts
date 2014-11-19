#!/bin/sh

. nsbase.sh

case $DIST in
  Debian|Ubuntu)
    $package_updateindex
    $package_install apache2
    ;;
  Fedora|CentOS|RHEL)
    $package_updateindex
    $package_install httpd
    ;;
  *)
    echo "not support $DIST"
esac

