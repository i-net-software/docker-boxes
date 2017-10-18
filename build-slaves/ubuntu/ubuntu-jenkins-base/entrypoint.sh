#!/bin/bash
set -e

if [ "$1" = 'daemon' ]; then
    exec /usr/sbin/sshd -D
    exit 0
fi

exec /usr/sbin/sshd

exec "$@"
