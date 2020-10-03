{
   # Hashes are shortened to avoid colossal query strings.
   # Increase this number if you get a message about hash collisions
   #   (and congrats on your video collection) !
   HASHLEN = 10

   # videos.dat record format
   hash = $1
   source = $2
   url = $3
   title = $4
   saved = $5

   video = sprintf("/data/%s.mp4", hash)
   thumb = sprintf("/data/%s.jpg", hash)
   shash = substr(hash, 1, HASHLEN)

   printf "<span>"
   printf "<table style=\"border-spacing: 5px;\">"
   printf "<tr><td><a href=\"%s\"><img src=\"%s\"></a></td></tr>", video, thumb
   printf "<tr><td class=\"cc-title\"><input type=\"text\" class=\"cc-title\" "
   printf "id=\"%s\" onchange=\"changeTitle(event)\" value=\"%s\">", shash, title
   printf "</td></tr>", title
   printf "<tr><td class=\"cc-attrs\">"
   printf "<input type=\"checkbox\" class=\"del-tick\" name=\"h\" value=\"%s\">", shash
   printf "Saved: %s", saved
   printf " from <a class=\"cc-origin\" href=\"%s\">%s</a></td></tr>", url, source
   printf "</table>"
   printf "</span>"
   printf "\n"
}
