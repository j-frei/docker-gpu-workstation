#!/usr/bin/env bash

if [ -z "$MAIN_UID" ]; then
    MAIN_UID=1000
fi

# Configure default non-root user 'main' if not existing
if ! getent passwd "$MAIN_UID" >/dev/null 2>&1; then
    sudo -u root groupadd -g $MAIN_UID -o main
    sudo -u root useradd -m -u $MAIN_UID -g $MAIN_UID -o -s /bin/bash main
    sudo -u root usermod -aG sudo main
    sudo -u root sh -c "echo 'main:template' | chpasswd"

    # try to set ownership for given directories
    if [ ! -z "$FIX_DIRS" ]; then
        sudo -u root chown -R $MAIN_UID:$MAIN_UID ${FIX_DIRS[$i]}
    fi
fi
