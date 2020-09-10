# Mastermind

View the [details](https://www.theodinproject.com/courses/ruby-programming/lessons/oop) on this object-oriented programming project from The Odin Project's Ruby course.

### Play

Play this Mastermind game on [repl.it](https://repl.it/@dmmurphy/MasterMind#game.rb)

### Project

This take on the classic [Mastermind board game](https://en.wikipedia.org/wiki/Mastermind_(board_game)) runs on the command line. Color coded numbers are used in place of board pegs. 

The player can choose to be Code Master or Code Breaker. As Code Master, the player picks a four digit code using the numbers 1 - 6 that the computer must break. Numbers can be used more than once. 

As Code Breaker, the computer generates a random four digit code that the player must guess. Clues are displayed for correct numbers in the correct position and for correct numbers in the wrong position. The player gets 12 turns to crack the code before the game ends.

### Details

For the computer's code solving algorithm, this version of Mastermind uses the Swaszek solution, adapted from Knuth's alogirthm. 



