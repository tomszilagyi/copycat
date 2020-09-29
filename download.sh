#!/bin/bash

#
# Download a video defined by the URL supplied as argument
# and append it to the copycat database.
#

[ -z "$1" ] && echo "Error: No URL is supplied!" && exit 1
url=$1

cd $(dirname $0)/data/incoming

dllog=$(readlink -f download.$$.log)
exec > $dllog

echo "Downloading URL: $url"
youtube-dl --newline -f mp4 -o "%(title)s.%(ext)s" "$url"
rc=$?
[ $rc -ne 0 ] && echo "youtube-dl rc=$rc" && exit 1

lastDl=$(ls -t *.mp4 | head -1)
rc=$?
[ $rc -ne 0 ] && echo "No downloaded file found!" && exit 1

echo "Downloaded: $lastDl"
title=$(echo "$lastDl" | sed -e 's/.mp4$//')
echo "Title: $title"

hash=$(sha256sum "$lastDl" | cut -d ' ' -f 1)
echo "Hash: $hash"

date=$(date +"%Y-%m-%d %T")
echo "Date: $date"

cd - >/dev/null
cd $(dirname $0)/data

mv "incoming/$lastDl" "$hash.mp4"
ffmpegthumbnailer -i "$hash.mp4" -o "$hash.jpg" -s400 -t20
rc=$?
[ $rc -ne 0 ] && echo "Error: ffmpegthumbnailer: rc=$rc" && exit 1
convert "$hash.jpg" -resize 400x225 "$hash.jpg"

printf "%s\0%s\0%s\0%s\0%s\n" "$hash" "YouTube" "$url" "$title" "$date" > videos.dat.$$
cat videos.dat >> videos.dat.$$
mv videos.dat.$$ videos.dat

# This is picked up by the web client and triggers a redirect to main page
echo "DONE"

# Allow some time for the web client to pick this up, then clean up
sleep 2
rm -f $dllog
rm -f $(dirname $dllog)/$$.evt
