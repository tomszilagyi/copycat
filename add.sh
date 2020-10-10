#!/bin/bash

cat <<EOF
<!DOCTYPE html>
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>copycat</title>
</head><body>

<div class="console">
<h2>Adding video</h2>
EOF

# Restore double-slash after protocol lost to proxy url normalization
url=$(echo "$@" | sed -e 's|^\([^:]*\):/\([^/]\)|\1://\2|')

grep -q "$url" data/videos.dat
if [ $? -eq 0 ] ; then
   echo "<p class=\"errormsg\">Already downloaded: $url</p>"
   echo "</body></html>"
   exit 0
fi

#./test/mock_download.sh $url &
./download.sh $url &
dlpid=$!

cat <<EOF
<pre><div id="result"></div></pre>
</div>

<script type="text/javascript">
if (typeof(EventSource) !== "undefined") {
   var source = new EventSource("/ostream/$dlpid");
   source.onmessage = function (event) {
      document.getElementById("result").innerHTML = event.data;
      if (event.data.endsWith ("DONE")) // success, reload main page!
         window.location.href = "/";
      else if (event.data.endsWith ("ERROR")) // error, stop refreshing
         source.close ();
   };
}
else
{
   document.getElementById("result").innerHTML="Your browser doesn't receive server-sent events.";
}
</script>
</body></html>
EOF
