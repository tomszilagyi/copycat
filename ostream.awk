BEGIN {
   print "retry: 500"
   print "event: message"
   seen_dl = 0
   dl_line = ""
}

{
   if (match ($0, "^\\[download\\] +[0-9]"))
   {
      seen_dl = 1
      dl_line = $0
   }
   else
   {
      if (seen_dl)
      {
         print "data:", dl_line
         seen_dl = 0
      }
      print "data:", $0
   }
}

END {
   if (seen_dl)
      print "data:", dl_line
   print ""
}
