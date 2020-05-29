#!/bin/bash
# Student Name: Owen Bennett
# Student Number: 10480364
# Unit Code: CSP2101
# Unit Name: Scripting Languages
# Assessment: Assignment 3 Software Based Solution

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt
cat temp.txt | grep "jpg" | sed -e 's/<img src="//' -e 's/".*//' -e 's/^[ \t]*//' > url.txt
rm temp.txt

echo "Please select from the following options:"
echo 
echo "1) Download a specific thumbnail"
echo "2) Download ALL thumbnails"
echo "3) Dowload a range of images"
echo "4) Download a number of random images"
echo
while true; do 
    read -p "Enter the option number that matches your requirements: " selection
        if [[ $selection -ge 1 && $selection -le 4 ]]; then
            echo
            echo "You have selected option: $selection"
            echo
            break
        else
            echo "That is not a valid option"
            continue
        fi
done

case $selection in
    '1')
        while true; do
            while true; do
                read -p "Enter the specific thumbnail of the image you would like to download: " thumbnail
                if [ -e $thumbnail.jpg ]; then
                    echo "File already exists. Please select another image to download"
                    echo
                    continue 
                elif [[ $thumbnail =~ [DSC0][1-2][0-9]{3} ]]; then
                    echo "You have selected $thumbnail. Searching now."
                    break
                else
                    echo "Invalid input"
                    continue
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
        ;;
    '2')
        if [ -d images ]; then
            rm -r images
        fi

        mkdir images
        echo "Downloading images into 'images' folder:"
        echo
        sleep 1
        
        file=url.txt

        for url in $(cat $file); do
            wget -q $url -P images/
            file_name=$(echo $url | awk -F / '{print $8}')
            image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
            file_size=$(du -b images/$file_name | awk '{printf "%3.2f", $1/1000}')
            unit=KB
            echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
        done

        echo
        echo "PROGRAM FINISHED"
        ;;
    '3')
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
        ;;
    '4')
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
        ;;
    *)
        echo 'Fail'
        exit 1
        ;;
esac

rm url.txt

exit 0