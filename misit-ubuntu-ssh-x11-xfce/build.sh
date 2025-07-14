#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"
set -e

# copy shared files temporarily into dir
for file in ../shared/*; do
    cp $file ./
done

tag_date=$(date '+%Y-%m-%d')
# build image
docker build -t misit/misit-ubuntu-ssh-x11-xfce:latest -t misit/misit-ubuntu-ssh-x11-xfce:$tag_date --pull .

# cleanup files
for file in ../shared/*; do
    rm $(basename $file)
done