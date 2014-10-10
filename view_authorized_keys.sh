#!/bin/bash

if [ -f ~/.ssh/authorized_keys ]; then
  cat ~/.ssh/authorized_keys
elif [ -f ~/.ssh/authorized_keys2 ]; then
  cat ~/.ssh/authorized_keys2
fi
