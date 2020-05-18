#!/bin/bash

secretFile=/home/owen/Documents/Bash/Scripting/CSP2101/workshop/week4/secret.txt

if [ -f $secretFile ]; then
    echo "the secret file exists"
    echo
    cat $secretFile
else
    echo "the secret file does not exist"
fi 
