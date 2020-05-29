#!/bin/bash
# Student Name: Owen Bennett
# Student Number: 10480364
# Unit Code: CSP2101
# Unit Name: Scripting Languages
# Assessment: Assignment 3 Software Based Solution

curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt
cat temp.txt | grep "jpg" | sed -e 's/<img src="//' -e 's/".*//' -e 's/^[ \t]*//' > url.txt
rm temp.txt

run_program='y'

while [[ $run_program == 'y' ]]; do

    echo "Please select from the following options:"
    echo 
    echo "  To download a SPECIFIC thumbnail----------Enter [1]"
    echo "  To download ALL thumbnails----------------Enter [2]"
    echo "  To download a RANGE of images-------------Enter [3]"
    echo "  To download a number of RANDOM images-----Enter [4]"
    echo
    while true; do 
        read -p "Enter the option number that matches your requirements: " selection
        echo
            if [[ $selection -ge 1 && $selection -le 4 ]]; then
                echo "You have selected option: $selection"
                echo
                sleep 1
                break
            else
                echo "INVALID OPTION! Please select on of the available options."
                echo
                continue
            fi
    done

    case $selection in
        '1')
            while true; do
                while true; do
                    read -p "Enter the specific thumbnail of the image you would like to download: " thumbnail
                    echo
                    if [ -e $thumbnail.jpg ]; then
                        echo "FILE ALEADY EXISTS! Please select another image to download"
                        echo
                        continue 
                    elif [[ $thumbnail =~ [DSC0][1-2][0-9]{3} ]]; then
                        echo "You have selected $thumbnail. Searching now:"
                        echo
                        sleep 1
                        break
                    else
                        echo "INVALID INPUT!"
                        echo
                        continue
                    fi
                done

                cat url.txt | grep $thumbnail > specific_image.txt

                if [ -s specific_image.txt ]; then
                    wget -q -i specific_image.txt
                    filesize=$(du -b $thumbnail.jpg | awk '{printf "%3.2f", $1/1000}')
                    unit=KB
                    echo "Downloading $thumbnail, with the filename $thumbnail.jpg, with a filesize of $filesize $unit...File Download Complete"
                    rm specific_image.txt
                    break
                else
                    echo   
                    sleep 1    
                    echo "FILE NOT FOUND! Check the image thumbnail and try again."
                    rm specific_image.txt
                    echo
                fi
            done
            ;;
        '2')
            if [ -d images ]; then
                rm -r images
            fi

            mkdir images
            echo "Downloading into 'images' folder:"
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
            ;;
        '3')
            cat url.txt | awk -F / '{print $8}' | sed 's/DSC0//; s/.jpg//' > id_numbers.txt

            while true; do
                read -p "Enter a 4 digit number for the STARTING range value: " start
                if [[ $start -ge 1500 && $start =~ ^[0-9]{4}$ ]]; then
                    break
                else
                    echo
                    echo "INVALID INPUT!"
                    echo
                    continue
                fi
            done

            while true; do
                read -p "Enter a 4 digit number for the ENDING range value: " end
                echo
                if [[ $end -gt $start && $end =~ ^[0-9]{4}$ ]];then 
                    break
                else
                    echo "INVALID INPUT! Enter a 4 digit number."
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
                echo "Sorry, no files found in that range."
            fi

            rm id_numbers.txt
            ;;
        '4')
            while true; do
                read -p "Enter how many random images required: " random
                echo
                max=$(wc -l url.txt | awk '{print $1}')
                if ! [[ $random =~ ^[0-9]+$ ]]; then
                    echo "INVALID INPUT! Enter a number"
                    echo
                elif [[ $random -gt $max ]]; then
                    echo "Value exceeds number of available images! Input a lower value."
                    echo
                elif [[ $random -le $max && $random -gt 0 ]]; then
                    echo "Selecting random images now:"
                    echo
                    break
                    sleep 1        
                else
                    echo "INVALID INPUT! Enter a number"
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
            ;;
        *)
            echo 'Fail'
            exit 1
            ;;
    esac

    echo
    read -p 'Run program again? [Enter y for yes] ' run_program
    echo
    continue

done

rm url.txt

echo "PROGRAM FINISHED"

exit 0