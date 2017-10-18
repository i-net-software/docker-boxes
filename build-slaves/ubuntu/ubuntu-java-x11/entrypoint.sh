#!/bin/bash
set -e

if [ "$1" = 'daemon' ]; then
    exec /usr/bin/supervisord -n
    exit 0
fi

exec /usr/bin/supervisord

exec "$@"
