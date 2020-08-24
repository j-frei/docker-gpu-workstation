#!/bin/bash

if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "Container startup... Setup environment..."

    if [ ! -z "$TF_FORCE_GPU_ALLOW_GROWTH" ]; then
        echo "TF_FORCE_GPU_ALLOW_GROWTH=$TF_FORCE_GPU_ALLOW_GROWTH" >> /etc/environment
    fi

    touch /etc/misit-docker-runonce.lock
fi