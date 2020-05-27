#!/bin/bash

if [ -d all_images ]; then
    rm -r all_images
fi

mkdir all_images/

wget -i urls.txt -P all_images -q

ls -l all_images | awk '{print $9}' > imageFiles.txt

while read p; do 
    echo "$p"
done < imageFiles.txt

