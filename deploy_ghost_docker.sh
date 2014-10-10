#!/bin/sh

docker pull smalldocker/ghost:latest

mkdir -p $HOME/ghost/content/{data,images,themes}

tmp_name=ghost_${RANDOM}

docker run --rm --name $tmp_name smalldocker/ghost sleep 10 &

sleep 2

docker cp $tmp_name:/ghost/config.example.js $HOME/ghost/config.js

docker run -d -v $HOME/ghost:/ghost-override -p 80:2368 smalldocker/ghost

echo "> you can custom config.js in $HOME/ghost/"
