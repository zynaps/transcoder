#!/usr/bin/env bash

set -x

if [[ "$1" = "/transcode.sh" ]]; then
    exec gosu $PUID:$PGID "$@"
fi

exec "$@"
