#!/bin/bash
# ask the user to display to contents of a file with cat

rtdir=/media/owen/Linux_files/Scripting/CSP2101
read -p "Enter the name of the file you are looking for: " secretFile

cd $rtdir
find -mindepth 1 -maxdepth 1 -type d | while read -r dir
do 
cd "$dir"
    if [[ $(find -name $secretFile\*) ]]; then
        i=$(find -name $secretFile\*)
        echo -n "${dir//.}"
        echo -n "${i#?}"
        echo " contains "
        cat $i
    fi 
cd $rtdir
done