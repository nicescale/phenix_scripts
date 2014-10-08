#!/bin/sh

docker pull smalldocker/ghost:latest

mkdir $HOME/ghost

docker run -d -v $HOME/ghost:/ghost-override -p 80:2368 smalldocker/ghost
