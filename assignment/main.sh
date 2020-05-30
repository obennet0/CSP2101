#!/bin/bash
# Student Name: Owen Bennett
# Student Number: 10480364
# Unit Code: CSP2101
# Unit Name: Scripting Languages
# Assessment: Assignment 3 Software Based Solution

echo
echo "Establishing Connection..."
curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt
cat temp.txt | grep "jpg" | sed -e 's/<img src="//; s/".*//; s/^[ \t]*//' > url.txt
rm temp.txt
echo
echo "Connection Successful"

run_program='y'

while [[ $run_program == 'y' ]]; do

    echo
    echo "Please select one the following options:"
    echo 

    while true; do 

        echo "  To download a SPECIFIC thumbnail---------------Enter [1]"
        echo "  To download ALL thumbnails---------------------Enter [2]"
        echo "  To download a RANGE of images------------------Enter [3]"
        echo "  To download a number of images at RANDOM-------Enter [4]"
        echo
        read -p "Enter the option number that matches your requirements: " selection
        echo

            if [[ $selection -ge 1 && $selection -le 4 ]]; then
                echo "You have selected option: $selection"
                echo
                break
            else
                echo "INVALID OPTION! Please select from the available options."
                echo
                
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
                    elif [[ $thumbnail =~ [DSC0][0-9]{4} ]]; then
                        echo "You have selected $thumbnail. Searching now..."
                        echo
                        sleep 1
                        break
                    else
                        echo "INCORRECT FILE NAME! Check the image thumbnail and try again."
                        echo                        
                    fi
                done

                cat url.txt | grep $thumbnail > specific_image.txt

                if [ -s specific_image.txt ]; then
                    wget -q -i specific_image.txt
                    file_size=$(du -b $thumbnail.jpg | awk '{printf "%3.2f", $1/1000}')
                    unit=KB
                    echo "Downloading $thumbnail, with the filename $thumbnail.jpg, with a file size of $file_size $unit...File Download Complete"
                    rm specific_image.txt
                    break
                else  
                    echo "FILE NOT FOUND! Check the image thumbnail and try again."
                    echo
                    rm specific_image.txt
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
            
            echo "Downloading into 'images' folder:"
            echo   

            file=url.txt

            for url in $(cat $file); do
                wget -q $url -P images
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
            cat url.txt | awk -F / '{print $8}' | sed 's/DSC0//; s/.jpg//' > id_number.txt

            while true; do 

                while true; do
                    read -p "Enter a 4 digit number for the STARTING range value: " start
                    if [[ $start =~ ^[0-9]{4}$ ]]; then
                        break
                    else
                        echo
                        echo "INVALID INPUT! Please enter a 4 digit number."
                        echo                        
                    fi
                done

                while true; do
                    read -p "Enter a 4 digit number for the ENDING range value: " end
                    echo
                    if [[ $end -le $start ]]; then
                        echo "INVALID INPUT! Ending value must be higher than the starting value."
                        echo
                    elif [[ $end -gt $start && $end =~ ^[0-9]{4}$ ]];then 
                        break
                    else
                        echo "INVALID INPUT! Please enter a 4 digit number."
                        echo                        
                    fi
                done

                file=id_number.txt
    
                for id in $(cat $file); do
                    if [[ $id -ge $start && $id -le $end ]]; then
                        grep $id url.txt >> range_url.txt
                    fi
                done

                if [ -e range_url.txt ]; then
                    for url in $(cat range_url.txt); do
                                wget -q $url
                                file_name=$(echo $url | awk -F / '{print $8}')
                                image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
                                file_size=$(du -b $file_name | awk '{printf "%3.2f", $1/1000}')
                                unit=KB
                                echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
                    done 
                    rm range_url.txt
                    break
                else
                    echo "Sorry, no files found in that range."
                    echo                    
                fi
            done

            rm id_number.txt

            echo
            echo "PROGRAM FINISHED"
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
            echo
            echo "PROGRAM FINISHED"
            ;;
        *)
            echo 'Fail'
            exit 1
            ;;
    esac

    echo
    read -p 'Run program again? [Enter y for yes] ' run_program
    echo
    

done

rm url.txt

echo "PROGRAM TERMINATED, GOODBYE"
echo

exit 0