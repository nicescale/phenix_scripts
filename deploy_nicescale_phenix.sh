#!/bin/bash

set -e

mkdir -p /data/phenix/{mongodb,keys,jobworker,public_scripts} 2>/dev/null || true

JOBWORKER_PORT=9997
KEYSERVER_PORT=9998
API_PORT=9999

PRIVKEY_PATH=/data/phenix/jobworker/privkey.pem
PUBKEY_PATH=/data/phenix/keys/pubkey.pem

if [ ! -f $PUBKEY_PATH -o ! -f $PRIVKEY_PATH ]; then
  openssl genrsa -out $PRIVKEY_PATH 2048
  openssl rsa -in $PRIVKEY_PATH -outform PEM -pubout -out $PUBKEY_PATH
fi

# pull docker image
docker pull docker.nicescale.com:5000/nicescale/mongodb:latest
docker pull docker.nicescale.com:5000/nicescale/phenix-jobworker:latest
docker pull docker.nicescale.com:5000/nicescale/phenix-keyserver:latest
docker pull docker.nicescale.com:5000/nicescale/phenix-api:latest
docker pull docker.nicescale.com:5000/nicescale/phenix-www:latest
docker tag docker.nicescale.com:5000/nicescale/mongodb nicescale/mongodb
docker tag docker.nicescale.com:5000/nicescale/phenix-jobworker nicescale/phenix-jobworker
docker tag docker.nicescale.com:5000/nicescale/phenix-keyserver nicescale/phenix-keyserver
docker tag docker.nicescale.com:5000/nicescale/phenix-api nicescale/phenix-api
docker tag docker.nicescale.com:5000/nicescale/phenix-www nicescale/phenix-www

[ -f /data/phenix/mongodb/data ] || mkdir -p /data/phenix/mongodb/data
docker run -it -d --name=phenix-mongodb -v /data/phenix/mongodb/data:/data nicescale/mongodb

docker run -d -v $PRIVKEY_PATH:/tmp/jobworker.pem:ro --name jobworker -p $JOBWORKER_PORT:5919 nicescale/phenix-jobworker

docker run -d --name=phenix-keys -v /data/phenix/keys:/data -p $KEYSERVER_PORT:80 -e KEY_SERVER_DATA_DIR=/data nicescale/phenix-keyserver

IP=$(/sbin/ip ad|grep -P 'inet \d+\.\d+\.\d+\.\d+'|cut -f1 -d'/'|awk '{print $2}'|grep -v 127.0.0.1|grep -v -P '\d+\.\d+\.\d+\.1$'|head -1)
git clone https://github.com/nicescale/phenix_scripts.git /data/phenix/public_scripts
docker run -d --name=phenix-api -e KEY_SERVER_URL=http://$IP:$KEYSERVER_PORT -e JOB_WORKER_URL=http://$IP:$JOBWORKER_PORT -e DB_NAME=phenix --link=phenix-mongodb:mongodb -v /data/phenix/public_scripts:/tmp/scripts:ro -p $API_PORT:80 nicescale/phenix-api

docker run -d --name phenix-console --link phenix-api:api -p 80:80 nicescale/phenix-www 
