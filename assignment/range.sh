#!/bin/bash

cat url.txt | awk -F / '{print $8}' | sed 's/DSC0//; s/.jpg//' > id_numbers.txt

while true; do
    read -p "Enter a 4 digit number for the starting range: " start
    if [[ $start -ge 1500 && $start =~ ^[0-9]{4}$ ]]; then
        break
    else
        echo
        echo "Invalid input"
        echo
        continue
    fi
done

while true; do
    read -p "Enter a 4 digit number for the ending range value: " end
    echo
    if [[ $end -gt $start && $end =~ ^[0-9]{4}$ ]];then 
        break
    else
        echo "Invalid input"
        echo
        continue
    fi
done

file=id_numbers.txt

for id in $(cat $file); do
    if [[ $id -ge $start && $id -le $end ]]; then
        grep $id url.txt >> range_url.txt
    fi
done

if [ -e range_url.txt ]; then
    for url in $(cat range_url.txt); do
                wget -q -N $url
                file_name=$(echo $url | awk -F / '{print $8}')
                image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
                file_size=$(du -b $file_name | awk '{printf "%3.2f", $1/1000}')
                unit=KB
                echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
    done 
    rm range_url.txt
else
    echo "Sorry, no files found in that range"
fi

rm id_numbers.txt

echo 
echo "PROGRAM FINISHED"