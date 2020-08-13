#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"

# build image
docker build -t misit/misit-ubuntu-ssh-x11:latest --pull .
