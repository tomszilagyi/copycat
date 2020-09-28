#!/bin/bash

# Regenerate thumb images.
# This should only be used manually as needed, not after each video insert!

echo -n "Regenerating thumbnails "
for vid in data/*.mp4
do
   thm=$(echo $vid | sed -e 's/.mp4$/.jpg/')
   ffmpegthumbnailer -i "$vid" -o "$thm" -s400 -t20
   convert "$thm" -resize 400x225 "$thm"
   echo -n "."
done
echo " DONE"
