#!/bin/bash

read -p "Enter the specific thumbnail you would like to download: " thumbnail

cat urls.txt | grep $thumbnail > specImage.txt

wget -q -i specImage.txt