#!/bin/bash

read -p "Enter how many random images required: " random
echo

shuf -n $random url.txt | sort > random_img.txt
file=random_img.txt

for url in $(cat $file); do
    wget -q $url
    file_name=$(echo $url | awk -F / '{print $8}')
    image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
    file_size=$(du -b $file_name | awk '{printf "%3.2f", $1/1000}')
    unit=KB
    echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
done

rm random_img.txt

echo 
echo "PROGRAM FINISHED"
