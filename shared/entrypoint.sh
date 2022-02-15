#!/usr/bin/env bash

# Run only once at creation time
if [ ! -f /etc/misit-docker-runonce.lock ]; then
    echo "First container startup... Setup environment..."
    /envparser.py >> /etc/profile
    touch /etc/misit-docker-runonce.lock
fi

# Run additional commands on startup
/run-once.sh

# Run main docker command
# with variable replacements
exec $(eval echo "${@}")