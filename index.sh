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
<a href="/trashed"><button type="button" class="button">List trashed</button></a>
Search: <input id="search" type="text" size="40" autofocus>
<a onclick='addAllToPlaylist()'><button type="button" class="button">+ Playlist</button></a>
<div id="nav-right">
<a onclick='togglePlaylist()'><button type="button" id="toggle-playlist" class="button">Playlist</button></a>
<a onclick='playThePlaylist()'><button type="button" class="button">Play</button></a>
<a onclick='clearPlaylist()'><button type="button" class="button">Clear</button></a>
</div>
</div>

<div class="multicol">
<div id="left-col" class="left-col">
<div class="video-list">
EOF

tac data/videos.dat | awk -F '\0' -f index.awk

cat <<EOF
</div>
</div>
<div id="right-col" class="right-col">
<div id="playlist" class="playlist">
<span id="playlist-placeholder">
<p>Your playlist is empty.</p>
<p>Click on some videos to add them here, or type into the <b>Search</b> box
to narrow down your videos, then press <b>+ Playlist</b> to add the ones
shown.</p>
</span>
<span id="playlist-proto-item" class="playlist-item">Playlist proto-item</span>
</div>
</div>
</div>

</form>

<div id="player-layer" class="player-layer">
<div class="player-window">
<div class="player-header">
<span class="player-close">&times;</span>
<div class="player-title">Title of currently playing video</div>
</div>
<div class="player-body">
<video id="player" controls>Your browser does not support HTML video.</video>
</div>
</div>
</div>

</body></html>
EOF
