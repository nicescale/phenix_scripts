#!/bin/sh

set -e

PUBKEY_PATH=/data/phenix/keys/pubkey.pem
PRIVKEY_PATH=/data/phenix/jobworker/privkey.pem

mkdir -p /data/phenix/{mongodb,keys,jobworker} 2>/dev/null || true

JOBWORKER_PORT=9997
KEYSERVER_PORT=9998
API_PORT=9999

keyname=phenix_$RANDOM
ssh-keygen -b 2048 -t rsa -f /tmp/$keyname -q -N ""
[ -f $PUBKEY_PATH ] || mv /tmp/$keyname $PUBKEY_PATH
[ -f $PRIVKEY_PATH ] || mv /tmp/$keyname $PRIVKEY_PATH

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

docker run -d --name=phenix-api -e KEY_SERVER_URL=http://127.0.0.1:$KEYSERVER_PORT -e JOB_WORKER_URL=http://127.0.0.1:$JOBWORKER_PORT -e DB_NAME=phenix --link=phenix-mongodb:mongodb -p $API_PORT:80 nicescale/phenix-api

docker run -d --link phenix-api:api -p 80:80 nicescale/phenix-www 
