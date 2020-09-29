{
   printf "<tr class=\"trashed-items\">"
   printf "<td class=\"trashed-items\">%s</td>", $4
   printf "<td class=\"trashed-items\">%s</td>", $2
   printf "<td class=\"trashed-items\"><a class=\"cc-origin\" href=\"%s\">%s</a></td>", $3, $3
   printf "<td class=\"trashed-items\">%s</td>", $5
   printf "<td class=\"trashed-items\">%s</td>", $6
   printf "</tr>"
   printf "\n"
}
