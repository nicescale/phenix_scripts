#!/bin/bash

set -e

docker pull smalldocker/ghost:latest

mkdir -p $HOME/ghost/content/{data,images,themes}

tmp_name=ghost_${RANDOM}

docker run --rm --name $tmp_name smalldocker/ghost sleep 10 &

sleep 2

docker cp $tmp_name:/ghost/config.example.js $HOME/ghost/

mv $HOME/ghost/config.example.js $HOME/ghost/config.js

sed -i -e 's/127.0.0.1/0.0.0.0/' $HOME/ghost/config.js

DOCKER_NAME=myghost$RANDOM

docker ps --all | grep -q $DOCKER_NAME && docker rm $DOCKER_NAME

docker run -d --name=$DOCKER_NAME -v $HOME/ghost:/ghost-override -p 80:2368 smalldocker/ghost

echo "> ghost docker running, open your ghost blog in browser http://ip:80"

echo "> you can custom config.js in $HOME/ghost/, then run: docker restart $DOCKER_NAME"
