{
   video = sprintf("/data/%s.mp4", $1)
   thumb = sprintf("/data/%s.jpg", $1)

   printf "<span>"
   printf "<table style=\"border-spacing: 5px;\">"
   printf "<tr><td colspan=\"2\"><a href=\"%s\"><img src=\"%s\"></a></td></tr>", video, thumb
   printf "<tr><td class=\"cc-title\" colspan=\"2\">%s</td></tr>", $4
   printf "<tr><td class=\"cc-saved\">Saved: %s</td>", $5
   printf "<td class=\"cc-origin\">From: <a class=\"cc-origin\" href=\"%s\">%s</a></td></tr>", $3, $2
   printf "</table>"
   printf "</span>"
   printf "\n"
}
