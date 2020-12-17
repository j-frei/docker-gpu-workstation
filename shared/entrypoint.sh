#!/bin/bash

if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "Container startup... Setup environment..."
    /envparser.py >> /etc/profile
    touch /etc/misit-docker-runonce.lock
fi
