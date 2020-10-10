#!/bin/bash

cat <<EOF
<!DOCTYPE html>
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<title>copycat</title>
</head><body>

<div class="console">
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

tac data/trash.dat | awk -F '\0' -f trashed.awk

cat <<EOF
</table>
</div>
</body></html>
EOF
