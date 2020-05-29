#!/bin/bash

while true; do
    read -p "Enter how many random images required: " random
    echo
    max=$(wc -l url.txt | awk '{print $1}')
    if ! [[ $random =~ ^[0-9]+$ ]]; then
        echo "Thats not a number!"
        echo "try again"
        echo
    elif [[ $random -gt $max ]]; then
        echo "Thats too many images"
        echo "Input a lower number"
        echo
    elif [[ $random -le $max && $random -gt 0 ]]; then
        echo "Selecting random images now."
        echo
        break
        sleep 1        
    else
        echo "Invalid input. Enter a number"
        echo
    fi
done 

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
