#!/bin/bash

#
# Download a video defined by the URL supplied as argument
# and append it to the copycat database.
# Also supports playlists, in which case all videos will be
# downloaded.
#

[ -z "$1" ] && echo "Error: No URL is supplied!" && exit 1
url=$1

datadir=$(readlink -f $(dirname $0)/data)
cd $(dirname $0)/data/incoming

dllog=$(readlink -f download.$$.log)
exec > $dllog

function cleanup () {
    # Allow some time for the web client to pick this up, then clean up
    sleep 2
    rm -f $dllog
    rm -f $(dirname $dllog)/$$.evt
}
trap cleanup EXIT

echo "Downloading URL: $url"

# This seems to be the best universal option for HTML5 player compatibility
dlfmt="bestvideo[ext=mp4]+bestaudio[ext=m4a]"

# Let's hope no extractor name will ever contain '+=+=+'
outfmt="%(extractor)s+=+=+%(title)s.%(ext)s"

youtube-dl --newline -f "$dlfmt" -o "$outfmt" "$url" 2>&1
rc=$?
if [ $rc -ne 0 ] ; then
    echo "youtube-dl rc=$rc"
    echo "ERROR" # signal web client
    exit 1
fi

# Loop to handle multiple videos (in case we got directed at a playlist):
while true
do
    lastDl=$(ls -rt *.mp4 | head -1)
    if [ -z "$lastDl" ]; then
        echo "No more downloaded files."
        break
    fi

    echo "Downloaded: $lastDl"
    source=$(echo "$lastDl" | sed -e 's/+=+=+.*$//')
    echo "Source: $source"
    title=$(echo "$lastDl" | sed -e 's/^.*+=+=+//' -e 's/.mp4$//')
    echo "Title: $title"

    hash=$(sha256sum "$lastDl" | cut -d ' ' -f 1)
    echo "Hash: $hash"

    date=$(date +"%Y-%m-%d %T")
    echo "Date: $date"

    mv "$lastDl" "$datadir/$hash.mp4"
    ffmpegthumbnailer -i "$datadir/$hash.mp4" -o "$datadir/$hash.jpg" -s400 -t20
    rc=$?
    if [ $rc -ne 0 ] ; then
        echo "Error: ffmpegthumbnailer: rc=$rc"
        echo "ERROR" # signal web client
        exit 1
    fi
    convert "$datadir/$hash.jpg" -resize 400x225 "$datadir/$hash.jpg"

    printf "%s\0%s\0%s\0%s\0%s\n" "$hash" "$source" "$url" "$title" "$date" \
           >> $datadir/videos.dat
done

echo "DONE" # signal web client
