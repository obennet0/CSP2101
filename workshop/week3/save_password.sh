#!/bin/bash

while true; do
read -p "What folder would you like to view? " foldername   # Asks the user to select a folder
if [ -d $foldername ]; then
    echo "You have selected $foldername"
    ls $foldername
    cd $foldername                                          # Changes dir to users choice
    break
else
    echo "$foldername does not exist"
fi
done                                                        
read -s -p "What password do you want to save? " password   # Asks the user for a password
echo $password > secret.txt                                 # Stores the password into text file
echo 
exit 0