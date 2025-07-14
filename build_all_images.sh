#!/bin/bash
# move to directory of script
cd "$(dirname "$0")"
set -e

for img_build in ./misit-*/build.sh; do
    echo "Running $img_build..."
    ./$img_build
done