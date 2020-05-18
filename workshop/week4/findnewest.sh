#!/bin/bash

# Compare three (3) files passed as parameters when the script is run
    # If <3 arguments passed to script, advise user and terminate script 
    # If all arguments are files, determine which file is the newest

# Test 1: ./findnewest.sh calc_rect_area.sh sspw.sh secret.txt
# Test 2: ./findnewest.sh calc_rect_area.sh 216 secret.txt

if ! [ $# -eq 3 ]; then
    echo "Incorrect number of arguments provided. Exiting script."
    exit 1
fi 

filecount=0
newestfile=""

for i; do

    if [[ -f $i ]]; then
        # what to do if true
        
        (( filecount++ ))
        echo "$i is a file."

        if [[ $filecount < 1 ]]; then
            newestfile=$i 
        else

            if [[ $i -nt $newestfile ]]; then
                newestfile=$i
            fi
        fi

    else 
        # what to do if false
        echo "$i is not a file."
    fi


done

echo "File count is set to $filecount"
echo "Arguments passed is set to $#" # $# is default bash to count number of arguments

if [[ (( $filecount -eq $# )) ]]; then 
    echo "The newest file is $newestfile"
else
    echo "Insufficient files for comparision."
fi

exit 0