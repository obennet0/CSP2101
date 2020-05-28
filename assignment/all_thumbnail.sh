#!/bin/bash

if [ -d all_images ]; then
    rm -r all_images
fi

mkdir all_images/
file=url.txt

for url in $(cat $file); do
    wget -q $url -P all_images/
    file_name=$(echo $url | awk -F / '{print $8}')
    image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
    file_size=$(du -b all_images/$file_name | awk '{printf "%3.2f", $1/1000}')
    unit=KB
    echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
done

echo
echo "PROGRAM FINISHED"