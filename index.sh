#!/bin/bash

cat <<EOF
<html><head>
<meta charset="UTF-8">
<link rel="stylesheet" href="style.css">
<script src="js/jquery-3.3.1.min.js"></script>
<script src="js/jquery.searchable.js"></script>
<script src="js/main.js"></script>
<title>copycat</title>
</head><body>

<form id="trash" action="/trash" method="get">

<div id="nav">
<input type="submit" class="trash-button" value="Trash selected">
<a href="/trashed"><button type="button" class="list-trash-button">List trashed</button></a>
Search: <input id="search" type="text" size="40" autofocus>
</div>

<div class="video-list">
EOF

tac data/videos.dat | awk -F '\0' -f index.awk

cat <<EOF
</div>
</form>
</body></html>
EOF
