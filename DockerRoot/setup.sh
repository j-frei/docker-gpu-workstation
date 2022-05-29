#!/usr/bin/env bash

userid="$(id -u)"
username="$(whoami)"
password="template"
dockergid="$(getent group docker | cut -d: -f3)"

docker build \
  --build-arg MAINUSERNAME="$username" \
  --build-arg MAINUSERPASSWORD="$password" \
  --build-arg MAINUSERID="$userid" \
  --build-arg DOCKERGROUPID="$dockergid" \
  -t "dockerroot:${username}-${userid}" .