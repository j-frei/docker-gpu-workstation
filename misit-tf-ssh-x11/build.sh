#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"

# build image
docker build -t misit/misit-tf-ssh-x11:latest --pull .
