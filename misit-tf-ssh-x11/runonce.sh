#!/bin/bash

if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "Container startup... Setup environment..."
    python3 /envparser.py >> /etc/environment
    touch /etc/misit-docker-runonce.lock
fi
