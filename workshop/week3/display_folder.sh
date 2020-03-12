#!/bin/bash
read -p "What folder would you like to look into? " folderName  # Asks for the name of the folder you want to look into
ls "$folderName"                                                # Lists the contents of the folder 