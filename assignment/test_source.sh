#!/bin/bash

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt

cat temp.txt | grep "jpg" | sed -e 's/<img src="//' -e 's/".*//' -e 's/^[ \t]*//' > urls.txt
rm temp.txt

