#!/bin/bash

echo "<html><head>"
echo "<meta charset=\"UTF-8\">"
echo "<link rel=\"stylesheet\" href=\"style.css\">"
echo "<title>copycat</title>"
echo "</head><body>"

echo "<h2>Last saved videos</h2>"

awk -F '\0' -f index.awk data/data.csv

echo "</body></html>"
