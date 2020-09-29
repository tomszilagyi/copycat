#!/bin/bash

cat <<EOF
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>copycat</title>
</head><body>

<h2>Last saved videos</h2>

<form id="trash" action="/trash" method="get">
<p>
   <input type="submit" value="Trash selected">
   <a href="/trashed"><button type="button">List trashed</button></a>
</p>
EOF

awk -F '\0' -f index.awk data/videos.dat

cat <<EOF
</form>
</body></html>
EOF
