#!/bin/bash
# ask the user to display to contents of a file with cat
read -p "Enter the name of the file you are looking for: " secretFile
for i in $( find /media/owen/Linux_files/Scripting/CSP2101 -name $secretFile\* ); do
    
    if [ -s "$i" ]; then    # 
        # what to do if true
        echo "The content of $i are as follows: "
        cat $i 
    else
        # what to do if false
        echo "The $i file is empty"
    fi 

done
