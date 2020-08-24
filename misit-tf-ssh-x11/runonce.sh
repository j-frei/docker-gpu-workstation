#!/bin/bash

if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "Container startup... Setup environment..."
    env >> ~/.bashrc
    touch /etc/misit-docker-runonce.lock
fi