#!/bin/bash
while true; do
    while true; do
        read -p "Enter the specific thumbnail of the image you would like to download: " thumbnail
        if [ -e $thumbnail.jpg ]; then
            echo "File already exists. Please select another image to download"
            echo
             
        elif [[ $thumbnail =~ [DSC0][1-2][0-9]{3} ]]; then
            echo "You have selected $thumbnail. Searching now."
            break
        else
            echo "Invalid input"
            
        fi
    done

    cat url.txt | grep $thumbnail > specific_image.txt

    if [ -s specific_image.txt ]; then
        wget -q -i specific_image.txt
        filesize=$(du -b $thumbnail.jpg | awk '{printf "%3.2f", $1/1000}')
        unit=KB
        echo
        sleep 1
        echo "Downloading $thumbnail, with the filename $thumbnail.jpg, with a filesize of $filesize $unit...File Download Complete"
        rm specific_image.txt
        break
    else
        echo   
        sleep 1    
        echo "File not found. Check the image thumbnail and try again."
        rm specific_image.txt
        echo
    fi
done
echo
echo "PROGRAM FINISHED"