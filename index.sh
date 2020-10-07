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
<span id="playlist-proto-item" class="playlist-item">This is a video</span>
<span id="playlist-placeholder">
<p>Your playlist is empty.</p>
<p>Click on some videos to add them here, or type into the <b>Search</b> box
to narrow down your videos, then press <b>+ Playlist</b> to add the ones
shown.</p>
</span>
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
         <video id="player" controls>
            Your browser does not support HTML video.
         </video>
      </div>
      <!--
      <div class="player-footer">
         <p>Buttons to jump to previous/next video in playlist?</p>
      </div>
      -->
   </div>
</div>

<script type="text/javascript">
function changeTitle (event) {
   //console.log ("new title for " + event.target.id + ": " + event.target.value);
   fetch ("/settitle/" + event.target.id + "/" + event.target.value)
   .then (function (response) {
      return response.json();
   })
   .then (function (json) {
      console.log(json);
      if (json.result !== "ok")
         alert ("Could not save title on server!\nReason: " + json.reason);
   })
   .catch(function (error) {
      alert ("Error: " + error);
   });
}

var togglePlaylistButton = document.getElementById("toggle-playlist");
var isPlaylistOpen = false;
var leftCol = document.getElementById ("left-col");
var rightCol = document.getElementById ("right-col");
var playlist = document.getElementById ("playlist");
var playlistProtoItem = document.getElementById ("playlist-proto-item");
var currentPlaylistItem = null;

function togglePlaylist () {
   console.log("Playlist toggled");
   if (isPlaylistOpen)
   {
      isPlaylistOpen = false;
      togglePlaylistButton.style.backgroundColor = "#fff";
      togglePlaylistButton.style.fontWeight = "normal";
      playerLayer.style.width = "100%";
      leftCol.style.width = "100%";
      rightCol.style.width = "0%";
      rightCol.style.display = "none";
   }
   else
   {
      isPlaylistOpen = true;
      togglePlaylistButton.style.backgroundColor = "#afa";
      togglePlaylistButton.style.fontWeight = "bold";
      playerLayer.style.width = "75%";
      leftCol.style.width = "75%";
      rightCol.style.width = "25%";
      rightCol.style.display = "block";
   }
}

function addAllToPlaylist () {
   console.log("Add all to playlist");
   var lst = document.getElementsByClassName ("video-card");
   var i = 0;
   for (; i < lst.length; ++i) {
      if (lst [i].style.display !== "none")
         enqueueVideo (lst [i].id);
   }
}

function playThePlaylist () {
   console.log("Play the playlist");
   var lst = document.getElementsByClassName ("playlist-item");
   if (lst.length < 2)
   {
      stopAndClosePlayer ();
   }
   else
   {
      cueItemForPlayback (lst [1]);
   }
}

function clearPlaylist () {
   console.log("Clear the playlist");
   var lst = document.getElementsByClassName ("playlist-item");
   var i = lst.length - 1;
   for (; i > 0; --i) { // leave proto-item
      lst [i].parentNode.removeChild (lst [i]);
   }
   document.getElementById ("playlist-placeholder").style.display = "block";
}

var player = document.getElementById ("player");
var playerLayer = document.getElementById ("player-layer");
var playerBody = document.getElementsByClassName ("player-body") [0];
var playerTitle = document.getElementsByClassName ("player-title") [0];
var playerClose = document.getElementsByClassName ("player-close") [0];

function cueItemForPlayback (playlistItem)
{
   if (currentPlaylistItem !== null)
   {
      currentPlaylistItem.style.color = "#fff";
      currentPlaylistItem.style.fontWeight = "normal";
   }

   if (playlistItem === null)
   {
      const playlist_loop = false; // TODO add a toggle for this
      if (playlist_loop)
      {
         var lst = document.getElementsByClassName ("playlist-item");
         if (lst.length > 1)
            playlistItem = lst [1];
         else
         {
            stopAndClosePlayer ();
            return;
         }
      }
      else
      {
         stopAndClosePlayer ();
         return;
      }
   }

   currentPlaylistItem = playlistItem;
   currentPlaylistItem.style.color = "#afa";
   currentPlaylistItem.style.fontWeight = "bold";
   openAndStartPlayer (playlistItem.id);
}

function handleVideoEnding ()
{
   if (currentPlaylistItem === null)
   {
      stopAndClosePlayer ();
      return;
   }

   var nextPlaylistItem = currentPlaylistItem.nextElementSibling;
   cueItemForPlayback (nextPlaylistItem);
}

function openAndStartPlayer (hash)
{
   title = getTitle (hash);

   playerTitle.innerHTML = title;
   playerLayer.style.display = "block";

   player.src = "/data/" + hash + ".mp4";
   player.play ();

   adjustPlayerSize ();
}

function addToPlaylist (item)
{
   document.getElementById ("playlist-placeholder").style.display = "none";
   playlist.appendChild (item);
   item.scrollIntoView (false);
}

function enqueueVideo (hash)
{
   title = getTitle (hash);

   var newPlaylistItem = playlistProtoItem.cloneNode (true);
   newPlaylistItem.id = hash;
   newPlaylistItem.display = "block";
   newPlaylistItem.innerHTML = title;
   newPlaylistItem.onclick = function () {
      cueItemForPlayback (newPlaylistItem);
   };
   addToPlaylist (newPlaylistItem);
}

function stopAndClosePlayer ()
{
   player.pause ();
   playerLayer.style.display = "none";
}

player.onended = handleVideoEnding;
playerClose.onclick = stopAndClosePlayer;

window.onclick = function (event)
{
   if (event.target == playerLayer) // click outside player-window
   {
      stopAndClosePlayer ();
   }
}

function adjustPlayerSize ()
{
   var rect = playerBody.getBoundingClientRect ();
   hPadding = 40; // see CSS .player-body :padding
   h = window.innerHeight - rect.top - hPadding;
   player.style.maxHeight = "" + h + "px";
}

function adjustHeight ()
{
   hPadding = 46; // see CSS .player-layer :top
   h = window.innerHeight - hPadding;
   playlist.style.height = h;

   var c = document.getElementById ("left-col");
   c.style.height = h;
}

window.onload = function ()
{
   adjustPlayerSize ();
   adjustHeight ();
}

window.onresize = function ()
{
   adjustPlayerSize ();
   adjustHeight ();
}

function getTitle (hash)
{
   // The id of the test entry containing the video title is the hash,
   // truncated to the first HASHLEN characters (see index.awk).
   var shash = hash.substring (0, 10);
   var titleInputBox = document.getElementById (shash);
   return titleInputBox.value;
}

function selectVideo (hash)
{
   console.log("selectVideo: " + hash);

   if (isPlaylistOpen)
      enqueueVideo (hash);
   else
      openAndStartPlayer (hash);
}
</script>

</body></html>
EOF
