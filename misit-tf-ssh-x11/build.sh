#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"

# copy shared files temporarily into dir
for $file in "../shared/*"; do
    cp $file $(basename $file)
done

tag_date=$(date '+%Y-%m-%d')
# build image
docker build -t misit/misit-tf-ssh-x11:latest -t misit/misit-tf-ssh-x11:$tag_date --pull .

# cleanup files
for $file in "../shared/*"; do
    rm $(basename $file)
done