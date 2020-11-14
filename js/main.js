// Setup jquery-searchable
$(function ()
{
   $('.video-list').searchable ({
      selector         : 'span.video-card',
      childSelector    : 'input',
      searchField      : '#search',
      searchType       : 'helm',
      ignoreDiacritics : true,
      getContent       : function (elem)
      {
         return elem [0].value;
      },
      hide             : function (elem)
      {
         elem.fadeOut (100);
      },
      show             : function (elem)
      {
         elem.fadeIn (100);
      },
      onSearchActive   : function (elem, term)
      {
         elem.show ();
      },
   });
});

function changeTitle (event) {
   fetch (encodeURIComponent (
      "/settitle/" + event.target.id + "/" + event.target.value))
   .then (function (response) {
      return response.json();
   })
   .then (function (json) {
      console.log (json);
      if (json.result !== "ok")
         alert ("Could not save title on server!\nReason: " + json.reason);
   })
   .catch (function (error) {
      alert ("Error: " + error);
   });
}

function togglePlaylist () {
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
      rightCol.style.width = "25%"; // Sync with CSS !!!
      rightCol.style.display = "block";
   }
}

function addAllToPlaylist () {
   if (!isPlaylistOpen)
      togglePlaylist ();

   var lst = document.getElementsByClassName ("video-card");
   var i = 0;
   for (; i < lst.length; ++i) {
      if (lst [i].style.display !== "none")
         enqueueVideo (lst [i].id);
   }
}

function playThePlaylist () {
   var lst = document.getElementsByClassName ("playlist-item");
   if (lst.length < 2) // only the proto-item is present
      stopAndClosePlayer ();
   else
      cueItemForPlayback (lst [1]);
}

function clearPlaylist () {
   var lst = document.getElementsByClassName ("playlist-item");
   var i = lst.length - 1;
   for (; i > 0; --i) { // do not remove proto-item
      lst [i].parentNode.removeChild (lst [i]);
   }
   document.getElementById ("playlist-placeholder").style.display = "block";
}

function cueItemForPlayback (playlistItem)
{
   if (currentPlaylistItem !== null)
   {
      currentPlaylistItem.style.color = "#fff";
      currentPlaylistItem.style.fontWeight = "normal";
      currentPlaylistItem = null;
   }

   if (playlistItem === null)
   {
      const playlist_loop = false; // TODO add a toggle for this
      if (playlist_loop)
      {
         var lst = document.getElementsByClassName ("playlist-item");
         if (lst.length > 1)
            cueItemForPlayback (lst [1]);
         else
            stopAndClosePlayer ();
      }
      else
         stopAndClosePlayer ();
      return;
   }

   currentPlaylistItem = playlistItem;
   currentPlaylistItem.style.color = "#afa";
   currentPlaylistItem.style.fontWeight = "bold";
   openAndStartPlayer (playlistItem.id);
}

function handleVideoEnding ()
{
   if (currentPlaylistItem === null)
      stopAndClosePlayer ();
   else
      cueItemForPlayback (currentPlaylistItem.nextElementSibling);
}

function openAndStartPlayer (hash)
{
   playerTitle.innerHTML = getTitle (hash);
   playerLayer.style.display = "block";

   adjustPlayerSize ();

   player.src = "/data/" + hash + ".mp4";
   player.play ();
}

function addToPlaylist (item)
{
   document.getElementById ("playlist-placeholder").style.display = "none";
   playlist.appendChild (item);
   item.scrollIntoView (false);
}

function enqueueVideo (hash)
{
   var newPlaylistItem = playlistProtoItem.cloneNode (true);
   newPlaylistItem.id = hash;
   newPlaylistItem.display = "block";
   newPlaylistItem.innerHTML = getTitle (hash);
   newPlaylistItem.onclick = function ()
   {
      cueItemForPlayback (this);
   };
   addToPlaylist (newPlaylistItem);
}

function stopAndClosePlayer ()
{
   player.pause ();
   playerLayer.style.display = "none";
}

function adjustPlayerSize ()
{
   var rect = playerBody.getBoundingClientRect ();
   var hPadding = 40; // Sync with CSS .player-body :padding !!!
   var h = window.innerHeight - rect.top - hPadding;
   player.style.maxHeight = "" + h + "px";
}

function adjustHeight ()
{
   var hPadding = 46; // Sync with CSS .player-layer :top !!!
   var h = window.innerHeight - hPadding;
   h = "" + h + "px";
   leftCol.style.height = h;
   playlist.style.height = h;
}

function getTitle (hash)
{
   // The id of the text entry containing the video title is the hash,
   // truncated to the first HASHLEN characters (see index.awk).
   var shash = hash.substring (0, 10);
   var titleInputBox = document.getElementById (shash);
   return titleInputBox.value;
}

function selectVideo (hash)
{
   if (isPlaylistOpen)
      enqueueVideo (hash);
   else
      openAndStartPlayer (hash);
}

function init ()
{
   // N.B.: we are intentionally creating global variables here!
   togglePlaylistButton = document.getElementById ("toggle-playlist");
   isPlaylistOpen = false;
   leftCol = document.getElementById ("left-col");
   rightCol = document.getElementById ("right-col");
   playlist = document.getElementById ("playlist");
   playlistProtoItem = document.getElementById ("playlist-proto-item");
   currentPlaylistItem = null;

   player = document.getElementById ("player");
   player.onended = handleVideoEnding;
   playerLayer = document.getElementById ("player-layer");
   playerBody = document.getElementsByClassName ("player-body") [0];
   playerTitle = document.getElementsByClassName ("player-title") [0];
   playerClose = document.getElementsByClassName ("player-close") [0];
   playerClose.onclick = stopAndClosePlayer;
}

function setupWelcomeLinks ()
{
   // N.B.: we use JS here so we can refer to the actual copycat server address.
   var addFormat = document.getElementById ("add-format");
   if (addFormat === null)
      return;

   addFormat.innerHTML = window.location.href + "add/VIDEO-URL";
   var addBookmark = document.getElementById ("add-bookmark");
   addBookmark.href="javascript:location.href=\"" + window.location.href +
                    "add/\"+encodeURIComponent(location.href)";

   var addExample = document.getElementById ("add-example");
   addExample.href = window.location.href +
                     "add/https://www.youtube.com/watch?v=u1kZ9zYr7kk";
   addExample.innerHTML = addExample.href;
}

window.onclick = function (event)
{
   if (event.target == playerLayer) // click outside player-window
   {
      stopAndClosePlayer ();
   }
}

window.onresize = function ()
{
   adjustPlayerSize ();
   adjustHeight ();
}

window.onload = function ()
{
   init ();
   setupWelcomeLinks ();

   adjustPlayerSize ();
   adjustHeight ();
}
