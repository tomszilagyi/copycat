BEGIN {
   print "retry: 500"
   print "event: message"
}

{
   print "data:", $0
}

END {
   print ""
}
