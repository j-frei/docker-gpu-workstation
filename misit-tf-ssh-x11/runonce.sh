#!/bin/bash

if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "Container startup... Setup environment..."
    python3 /envparser.py > ~/.docker_env
    echo "source ~/.docker_env" >> ~/.bashrc  
    touch /etc/misit-docker-runonce.lock
fi
