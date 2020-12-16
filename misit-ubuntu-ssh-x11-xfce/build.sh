#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"

tag_date=$(date '+%Y-%m-%d')
# build image
docker build -t misit/misit-ubuntu-ssh-x11-xfce:latest -t misit/misit-ubuntu-ssh-x11-xfce:$tag_date --pull .
