#!/bin/bash

cat <<EOF
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>copycat</title>
</head><body>

<div class="console">
<h2>Trashing video(s)</h2>
<pre>
EOF

date=$(date +"%Y-%m-%d %T")
error=0
list=$(echo $@ | sed -e 's/?h=/ /' -e 's/&h=/ /g')
for h in $list; do
    n=$(awk -F '\0' "/$h/ {print \$1}" data/videos.dat | wc -l)
    case $n in
        0)
            echo "- $h: Not found! (This should not happen.)"
            error=1
            ;;
        1)
            # save record to trash.dat, amended with current timestamp
            awk -F '\0' \
                "/$h/ {printf (\"%s\0%s\n\", \$0, \"$date\")}" \
                data/videos.dat >> data/trash.dat

            # remove files
            hash=$(awk -F '\0' "/$h/ {print \$1}" data/videos.dat)
            rm -f data/$hash.mp4 data/$hash.jpg

            # remove line from videos.dat
            grep -a -v "^$hash" data/videos.dat > data/videos.$$.dat
            mv data/videos.$$.dat data/videos.dat

            echo "- $h: Trashed OK"
            ;;
        *)
            echo "- $h: Hash collision, increase HASHLEN in index.awk!"
            error=1
            ;;
    esac
done
echo "</div></pre>"

# Only auto-redirect back to main if everything was sunny day
if [ $error -eq 0 ] ; then
cat <<EOF
<script type="text/javascript">
   window.location.href = "/";
</script>
EOF
fi

echo "</body></html>"
