#!/bin/bash

if [ -d all_images ]; then
    rm -r all_images
fi

mkdir all_images/

wget -i url.txt -P all_images -q

# ls -l all_images | awk '{print $9}' > 