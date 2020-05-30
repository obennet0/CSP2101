#!/bin/bash

echo "Please select from the following options"
echo 
echo "1) Download a specific thumbnail"
echo "2) Download ALL thumbnails"
echo "3) Dowload a range of images"
echo "4) Download a specific number of images"
echo
while true; do 
    read -p "Enter the option number that matches your requirements: " selection
        if [[ $selection -ge 1 && $selection -le 4 ]]; then
            echo "You have selected option: $selection"
            break
        else
            echo "That is not a valid option"
            
        fi
done

echo $selection