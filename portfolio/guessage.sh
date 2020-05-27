#!/bin/bash
# Student Name: Owen Bennett
# Student Number: 10480364
# Unit: CSP2101-Scripting Languages
# Assignment 2 - Portfolio Submission 1

# This section is for storing repetitive text styling options
boldcyan="\033[36;1m"  # saves the ANSI cyan coloured bold statement for easy use later.
normal="\033[36;0m"    # returns the text back to the normal format.

# Welcome banner to the Guess Age game.
echo
echo -e $boldcyan"-------------------------------------"$normal
echo -e $boldcyan"Welcome to the Guess-Their-Age-Game!!"$normal
echo -e $boldcyan"-------------------------------------"$normal

# This section is just text explaining how to play the game
echo -e "To play the 'Guess-Their-Age-Game' simply enter an age and keep trying until you get it right."
echo -e "\n(HINT: Their age is between 20 and 100)"
echo -e "\n\033[32;4;1mGOOD LUCK!"$normal           # The 'good luck' text has been styled to bold/underlined green text


guessCounter=1                  # This initialises the guess counter and stores it in variable 'guessCounter'
((  age =  20 + RANDOM % 81 ))  # The mathematical operation to produce a random number using the in-built function RANDOM
                                # creates a random number between 20 and 100 which is stored into the variable 'age'

# This is the start of the Game 
while [[ $guess -ne $age ]]; do # Beginning of the while loop and sets the true value where the 'guess' does not equal the 'age'
    echo      
    read -p "Enter their age: " guess   # Asking for the users input and stores it in the variable 'guess'
    
    if [[ -z "$guess" || ! $guess =~ [0-9] ]]; then               # Start of if loop. Line is for error handling and does not allow for null OR alphabetical inputs
        echo -e "\n\t\033[31;1mInvalid input, try again."$normal  # Responds to users invalid input with bold red text
    elif [[ $guess -gt $age ]]; then                              # Else if the input is valid. Test if the guess is greater than the age
        echo -e "\n\tThey are not that old! Guess again."         # If the guess is greater than the age, tell user the guess is too high
        ((guessCounter++))                                        # Adds 1 to the guess counter variable
    elif [[ $guess -lt $age ]]; then                              # Else if test if the guess is less than the age
        echo -e "\n\tToo low! Guess again."                       # If true tell the user their guess is too low
        ((guessCounter++))                                        # Again, add 1 to the guess counter for incorrect guess
    fi

done                    

# While loop has been broken, show end-game message
echo -e "\n\033[32;1;5mCongratulations you guessed the right age!!"$normal              # Once guess equal the age, congratulate user with green blinking text
echo -e "--------- It took you $boldcyan$guessCounter$normal guess(es) ---------\n"     # Displays the number of guesses the user had
