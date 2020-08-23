# Project: Mastermind

https://www.theodinproject.com/courses/ruby-programming/lessons/oop

### Problem:

Make a game on the command line where the computer generates a random code of 4 digits using the numbers 1 - 6. The player will be asked to guess the code on each turn and the computer will give clues on any correct digits in correct positions as well as clues to any correct digits in the wrong positions. The player gets 12 turns to crack the code before the game ends.

### Original Pseudo Code:

~~~
Command line displays rules and clue keys
Computer generates random 4 digit code using numbers 1 - 6
Loop starts
  Command line prompts user for a guess
  Computer checks user's guess to match against computer's code
    If user's guess is correct, command line displays winner message
    If user's guess is wrong, command line displays the guess and any clues
      Computer checks each number of user's guess against code
        If one of the user numbers matches the code number in same position, command line
          displays symbol for correct digit in correct position
        If one of the user numbers matches the code number but in wrong position, command line
          displays symbol for correct digit in wrong position
  User's guessing counter increases by 1 for each guess
  Computer gives user a warning message prior to 12th (final) guess
  Computer checks for 12 incorrect guesses and ends the game if true
~~~

### Rubyish Pseudo Code:

~~~
Game class

  Initialize Game
    Create user variable and make new instance
    Create code variable and make new instance
  
  Show Rules
    Display the rules of the game
  
  Show Keys
    Display the keys to the clues

  Start Game
    Get Code
    Loop
      Get Guess
      Check Guess
        If true display winner result
        Else Display Guess
             Check Clues
             Check Counter 12
  
  Check Clues
    Show Keys
    Check D&P
    Check DO

  Check Counter 12
    Call player instance Show Counter
    If Counter variable equals 11, display warning final guess message
    If Counter variable equals 12, display game over message

  Check D&P (Correct Digit and Position)
    If Player guess has any correct digits in correct index position of code array,
      then return that number of D&P symbols
    
  Check DO (Correct Digit Only)
    If Player guess has any correct digits but in wrong index position of code array,
      then return that number of DO symbols

  Get Guess
    Loop
      Display prompt message to player for guess
      Call player instance Take Guess
        If true, assign to Current Guess Variable and break
        Else, reprompt message

  Get Code
    Call code instance Show Code
    Set Show Code to Code Variable

  Check Guess (Code Variable, Current Guess Variable)
    Check if Code Variable equals Current Guess Variable
  
  Display Guess (Current Guess Variable)
    Show color coded version of Current Guess Variable

End

Code class

  Generate Code
    Create code variable as 4 digit array of randomly generated
      numbers from 1 - 6
    
  Show Code
    Return code variable when called

End

Player class

  Initialize Player
    Create guess counter variable set to 0
  
  Take Guess
    Assign guess variable with prompt to user
    Increase Counter and return true if Check Valid

  Check Valid
    See if user guess contains 4 numbers between 1 - 6

  Increase Counter
    Increase number of guesses by 1

  Show Counter
    Return counter variable when called

End

~~~
