#!/usr/bin/env bash

userid="$(id -u)"
username="$(whoami)"
volume_mnt="/home/$username/docker"

if ! command -v nvidia-container-cli &> /dev/null; then
  gpu_args=""
  echo "NVIDIA-runtime is missing"
else
  gpu_args="--gpus all"
  echo "NVIDIA-runtime found"
fi


container_name="dockerroot_${username}_${userid}-$RANDOM"
docker run --rm --privileged -d \
  $gpu_args \
  -v "${volume_mnt}:${volume_mnt}" \
  -v /var/run/docker.sock:/var/run/docker.sock \
  --name="$container_name" \
  "dockerroot:${username}-${userid}"

cat <<EOF
Run: docker exec -it -u $userid $container_name bash
EOF