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

CHECK_DEPS convert ffmpeg ffmpegthumbnailer gawk sha256sum socat youtube-dl

cd $(dirname $0)
# Make sure directory structure exists
mkdir -p data/incoming
touch data/videos.dat
touch data/trash.dat

port=8799
echo "Launching socat/bashttpd listening on port $port ..."
socat TCP4-LISTEN:$port,bind=127.0.0.1,reuseaddr,fork EXEC:./bashttpd
