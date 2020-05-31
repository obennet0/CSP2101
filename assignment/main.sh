#!/bin/bash
# Student Name: Owen Bennett
# Student Number: 10480364
# Unit Code: CSP2101
# Unit Name: Scripting Languages
# Assessment: Assignment 3 Software Based Solution


# Colours and formats saved to be used throughout the script
error='\033[31;1m'
green='\033[32;1m'
mag='\033[35m'
normal='\033[0m'
blue='\033[36;1m'

# Uses curl to retrieve website data and stores that data in a temporary file.
# Then grep finds all instances of 'jpg' and sed formats the line so that only the url is left.
# Urls are stored in a text file which will be called upon throughout the script.
echo
echo "Establishing Connection..."
curl -s "https://www.ecu.edu.au/service-centres/MACSC/gallery/gallery.php?folder=152" > temp.txt
cat temp.txt | grep "jpg" | sed -e 's/<img src="//; s/".*//; s/^[ \t]*//' > url.txt
rm temp.txt
echo
echo "Connection Successful"
sleep 1

# Checks to see if the folder 'gallery' exists and deletes it if it does, then creates a fresh folder.
# This is mainly so that the program can be run multiple times without having to manually
# delete the folder every time
if [ -d gallery ]; then
    rm -r gallery
fi
mkdir gallery

# Initialises the variable 'run_program' so that the program can run through during the first run.
run_program='y'

# The beginning of the while loop that encapsulates the main body of the program.
while [[ $run_program == 'y' ]]; do
    echo
    echo -e "${bold}Please select one the following options:${normal}"
    echo 

    # Presents the list of options to the user and stores their choice in the variable 'selection'.
    while true; do
        echo "  To download a SPECIFIC thumbnail---------------Enter [1]"
        echo "  To download ALL thumbnails---------------------Enter [2]"
        echo "  To download a RANGE of images------------------Enter [3]"
        echo "  To download a number of images at RANDOM-------Enter [4]"
        echo "  To LIST file names in gallery------------------Enter [5]"
        echo
        read -p "Enter the option number that matches your requirements: " selection
        echo

            # Tests to see if the users input is within the range of options available.
            # If the users input does not match the options given they will be asked to select again.
            if [[ $selection -ge 1 && $selection -le 5 ]]; then
                break
            else
                echo -e "${error}INVALID OPTION!${normal} Please select from the available options:"
                echo
            fi
    done

    # Case statement that matches the users selection to the function that the user requires.
    case $selection in
        '1')
            # The first function retrieves a specific image from the website.
            # The user must enter a specific thumbnail that matches an image on the website.
            # There are test to see if the image already exists within the 'gallery' folder,
            # then it tests if the users input matches the format of a thumbnail found on the website.
            # If the test fail the user is prompted to select another image.
            while true; do
                while true; do
                    read -p "Enter the specific thumbnail of the image you would like to download: " thumbnail  
                    echo
                    if [ -e gallery/$thumbnail.jpg ]; then
                        echo -e "${error}FILE ALEADY EXISTS!${normal} Please select another image to download."
                        echo                         
                    elif [[ $thumbnail =~ [DSC0][0-9]{4} ]]; then
                        echo -e "${bold}You have selected${normal} $thumbnail. ${bold}Searching now...${normal}"
                        echo
                        sleep 1
                        break
                    else
                        echo -e "${error}INCORRECT FILE NAME!${normal} Check the image thumbnail and try again."
                        echo                        
                    fi
                done

                # Uses grep to search for a matching thumbnail then stores that url into a temporary text file.
                cat url.txt | grep $thumbnail > specific_image.txt

                # Tests to see if the text file is empty and thus no matches were found.
                # If an match is found it retrieves the image with wget and stores it into the 'gallery' folder.
                # Uses du to get the size in bytes then awk divides that size by 1000 to get kilobytes and displays that 
                # figure up to the 2nd decimal place.
                # If file is found displays the appropiate message containing the image number, file name with extension, and size.
                if [ -s specific_image.txt ]; then
                    wget -q -i specific_image.txt -P gallery
                    file_size=$(du -b gallery/$thumbnail.jpg | awk '{printf "%3.2f", $1/1000}')
                    unit=KB
                    echo "Downloading $thumbnail, with the filename $thumbnail.jpg, with a file size of $file_size $unit...File Download Complete"
                    break
                else  
                    echo -e "${error}FILE NOT FOUND!${normal} Check the image thumbnail and try again."
                    echo
                fi
            done

            # File no longer needed thus removing it cleans up the working directory
            rm specific_image.txt

            # Displays a message when download is complete
            echo
            echo -e $green"PROGRAM FINISHED"$normal
            ;;
        '2')
            # The second block of code retrieves ALL images found on the website.
            # Uses a for loop to iterate through every line within the url.txt file.
            # First creates the variable 'file_name' which uses awk with the seperator '/' to
            # gather the last segment of the line which is the file name of the image eg DSC01533.jpg 
            for url in $(cat url.txt); do
                file_name=$(echo $url | awk -F / '{print $8}')
                
                # Checks if the file name already exists within the 'gallery' folder
                if [ -e gallery/$file_name ]; then
                    echo -e $mag"The image $file_name already exists!"$normal
                    echo
                    sleep 0.2
                
                # Same process as within the first block, retrieves the image and stores it in 'gallery' folder.
                # Displays the image number, file name with extension, and size of file.
                else
                    wget -q $url -P gallery
                    image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
                    file_size=$(du -b gallery/$file_name | awk '{printf "%3.2f", $1/1000}')
                    unit=KB
                    echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
                    echo
                fi
            done

            echo
            echo -e $green"PROGRAM FINISHED"$normal
            ;;
        '3')
            # Third block of program locates images based within a range a values.
            # First the url.txt file is modified to only contain the image number which are stored in the 'id_number.txt' file.
            cat url.txt | awk -F / '{print $8}' | sed 's/DSC0//; s/.jpg//' > id_number.txt

            # Segment used to gather the starting value for the range function.
            # Only tests if the users input is a 4 digit number, if not, they are asked to try another input
            while true; do
                while true; do
                    read -p "Enter a 4 digit number for the [STARTING] range value: " start
                    if [[ $start =~ ^[0-9]{4}$ ]]; then 
                        break
                    else
                        echo
                        echo -e "${error}INVALID INPUT!${normal} Please enter a 4 digit number."
                        echo                        
                    fi
                done

                # Like above this segment is used to gather the ending value from the user.
                # An additional test is added to determine if the ending value is higher than the starting value.
                # If the user does not enter a 4 digit value higher than the starting value they will be prompted
                # to enter another ending value.
                while true; do
                    read -p "Enter a 4 digit number for the [ ENDING ] range value: " end
                    echo
                    if [[ $end -le $start ]]; then
                        echo -e "${error}INVALID INPUT!${normal} Ending value must be higher than the starting value."
                        echo
                    elif [[ $end =~ ^[0-9]{4}$ ]];then 
                        break
                    else
                        echo -e "${error}INVALID INPUT!${normal} Please enter a 4 digit number."
                        echo                        
                    fi
                done

                # Iterates through all the numbers that are within the range in the 'id_number.txt' file 
                # and uses grep to match those id numbers to the numbers found in the url.txt file.
                # Stores all matches into the 'range_url.txt' file.
                for id in $(cat id_number.txt); do
                    if [[ $id -ge $start && $id -le $end ]]; then
                        grep $id url.txt >> range_url.txt
                    fi
                done

                # First checks to see if previous for loop found any matches
                if [ -s range_url.txt ]; then

                    
                    for url in $(cat range_url.txt); do
                        file_name=$(echo $url | awk -F / '{print $8}')

                        # Checks if the file name already exists within the 'gallery' folder
                        if [ -e gallery/$file_name ]; then
                            echo -e $mag"The image $file_name already exists!"$normal
                            echo
                            sleep 0.2

                        # Same retrieve and display function as within the first 2 options.
                        else
                            wget -q $url -P gallery
                            image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
                            file_size=$(du -b gallery/$file_name | awk '{printf "%3.2f", $1/1000}')
                            unit=KB
                            echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
                            echo
                        fi
                    done 

                    # Removes temporary file to clean up working directory.
                    rm range_url.txt
                    break
                else
                    echo -e "${bold}Sorry, no files found in that range.${normal}"
                    echo                    
                fi
            done

            # Removes temporary file to clean up working directory.
            rm id_number.txt

            echo
            echo -e $green"PROGRAM FINISHED"$normal
            ;;
        '4')
            # Final option of the program which gathers a random number of images specified by the user.
            
            # Determines the number of lines within the url.txt. 
            # Because wc returns the number plus the file name, must use awk to gather only the number section.
            max=$(wc -l url.txt | awk '{print $1}')
            
            # Prompts user to enter the number of images they want and stores input in variable 'random'.
            # Multiple tests determine if the users input is:
            # A number, greater then the maximum number of images available, and is not 0.
            while true; do
                read -p "Enter how many random images required: " random
                echo                
                if ! [[ $random =~ ^[0-9]+$ ]]; then
                    echo -e $error"INVALID INPUT!"$normal "Enter a number"
                    echo
                elif [[ $random -gt $max ]]; then
                    echo "Value exceeds number of available images! Input a lower value."
                    echo
                elif [[ $random -gt 0 ]]; then
                    echo -e "${bold}Selecting images now:${normal}"
                    echo
                    break
                    sleep 1        
                else
                    echo -e "${error}INVALID INPUT!${normal} Enter a number"
                    echo
                fi
            done 

            # Uses in-built bash function 'shuf' to shuffle the lines within the url.txt file.
            # Then selects the users number of lines from the shuffled url.txt file.
            # Used sort so that the random images will still be in numerical order, then stored those
            # urls into the file 'random_img.txt'.
            shuf -n $random url.txt | sort > random_img.txt

            # Code segment is the same as in the previous 3 options.
            for url in $(cat random_img.txt); do
                file_name=$(echo $url | awk -F / '{print $8}')
                if [ -e gallery/$file_name ]; then
                    echo -e $mag"The image $file_name already exists!"$normal
                    echo
                    sleep 0.2
                else
                    wget -q $url -P gallery
                    image_num=$(echo $url | awk -F / '{print $8}' | sed 's/.jpg//')
                    file_size=$(du -b gallery/$file_name | awk '{printf "%3.2f", $1/1000}')
                    unit=KB
                    echo "Downloading $image_num, with the file name $file_name, with a file size of $file_size $unit...File Download Complete"
                    echo
                fi
            done 

            # Removes temporary file to clean up working directory.
            rm random_img.txt

            echo
            echo -e $green"PROGRAM FINISHED"$normal
            ;;
        '5')
            # An additional fifth option was added for testing purposes and simply lists what images are in the gallery folder. 
            ls gallery
            echo
            echo -e $green"PROGRAM FINISHED"$normal
            ;;
        *)
            echo 'Fail'
            exit 1
            ;;
    esac

    # Once an option coded block has completed user is given the option to run the program again.
    # If input is 'y' the program will go back to the top of the first while loop.
    echo
    read -p 'Run program again? [Enter y for yes] ' run_program
done

# Removes the url.txt file that has been used throughout the program. 
rm url.txt

# Final message to signal the end of program to the user.
echo
echo -e $green"PROGRAM TERMINATED, GOODBYE"$normal
echo

exit 0