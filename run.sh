#!/bin/bash

function CHECK_DEPS {
    TOOLS="$@"; shift
    MISSING=0
    for t in ${TOOLS} ; do
        which $t >/dev/null
        if [ $? -gt 0 ] ; then
            echo "ERROR: Missing dependency: $t"
            MISSING=1
        fi
    done
    if [ $MISSING -gt 0 ] ; then
        exit 1
    fi
}

CHECK_DEPS gawk socat sha256sum convert youtube-dl ffmpegthumbnailer

# Make sure directory structure exists
mkdir -p $(dirname $0)/data/incoming
touch $(dirname $0)/data/data.csv

port=8799
echo "Launching bashttpd listening on port $port ..."
socat TCP4-LISTEN:$port,fork EXEC:./bashttpd
