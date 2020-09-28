#!/bin/bash

echo "<html><head>"
echo "<meta charset=\"UTF-8\">"
echo "<link rel=\"stylesheet\" href=\"style.css\">"
echo "<title>copycat</title>"
echo "</head><body>"

echo "<h2>Adding video</h2>"

# Restore double-slash after protocol lost to proxy url normalization
url=$(echo "$@" | sed -e 's|^\([^:]*\):/\([^/]\)|\1://\2|')
echo "<p>URL: <code>$url</code></p>"
echo "$url" | grep -q "^https://www.youtube.com/watch?v="
if [ $? -ne 0 ] ; then
   echo "<p class=\"errormsg\">Not a YouTube video URL: $url</p>"
   echo "</body></html>"
   exit 0
fi

grep -q "$url" data/data.csv
if [ $? -eq 0 ] ; then
   echo "<p class=\"errormsg\">Already downloaded: $@</p>"
   echo "</body></html>"
   exit 0
fi

#./test/mock_download.sh $@ &
./download.sh $url &
dlpid=$!

cat <<EOF
<pre><div id="result"></div></pre>

<script type="text/javascript">
if (typeof(EventSource) !== "undefined") {
   var source = new EventSource("/ostream/$dlpid");
   source.onmessage = function (event) {
      document.getElementById("result").innerHTML = event.data;
      if (event.data.endsWith ("DONE")) // success, reload main page!
         window.location.href = "/";
   };
}
else
{
   document.getElementById("result").innerHTML="Your browser doesn't receive server-sent events.";
}
</script>
EOF

echo "</body></html>"
