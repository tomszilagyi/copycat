#!/bin/bash

cat <<EOF
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>copycat</title>
</head><body>

<h2>Trashed videos</h2>

<table>
<tr class=\"trashed-items\">
<th class=\"trashed-items\">Title</th>
<th class=\"trashed-items\">Source</th>
<th class=\"trashed-items\">URL</th>
<th class=\"trashed-items\">Saved</th>
<th class=\"trashed-items\">Trashed</th>
</tr>
EOF

awk -F '\0' -f trashed.awk data/trash.dat

cat <<EOF
</table>
</body></html>
EOF
