#!/bin/bash

shash=$(echo $@ | sed -e 's|/.*$||')
title=$(echo $@ | sed -e 's|^.*/||')

n=$(awk -F '\0' "/$shash/ {print \$1}" data/videos.dat | wc -l)
case $n in
    0)
        msg="$shash: Not found! (This should not happen.)"
        error=1
        ;;
    1)
        # exactly one match - update title in matching record
        cp data/videos.dat data/videos.dat.save
        awk -F '\0' \
            "/^$shash/ {printf (\"%s\0%s\0%s\0%s\0%s\n\", \$1, \$2, \$3, \"$title\", \$5)} \
             ! /^$shash/ {print \$0}" \
            data/videos.dat >> data/videos.dat.$$
        mv data/videos.dat.$$ data/videos.dat

        msg="$shash: Title changed OK"
        error=0
        ;;
    *)
        msg="$shash: Hash collision, increase HASHLEN in index.awk!"
        error=1
        ;;
esac

if [ $error -eq 0 ] ; then
    echo "{\"result\": \"ok\", \"reason\": \"$msg\"}"
else
    echo "{\"result\": \"error\", \"reason\": \"$msg\"}"
fi

exit $error
