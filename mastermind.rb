
class Game

  def initialize
    @player = Player.new
    @code = Code.new
  end

  def show_rules
    puts <<-HEREDOC
    
    Welcome to Mastermind!

    You have 12 turns to break the computer's code. For each turn, 
    enter a 4 digit guess choosing from the numbers 1 - 6. A number
    can be used more than once.

    If you guess incorrectly, you will be given clues to help with
    you next guess.

    May the odds be ever in your favor.

    HEREDOC
  end
  
  def show_keys
    puts <<-HEREDOC
    
    These are the symbols in the game:
    Each ! means you guessed a correct number in a correct position
    Each ? means you guessed a correct number but in the wrong position
    If no symbols appear, you didn't guess any correct numbers

    HEREDOC
  end
  
  def start_game
    show_rules
    show_keys
    get_code
    @player.take_guess
    p @player.current_guess
    #Get Code
    #Loop
      #Get Guess
      #Check Guess
        #If true display winner result
        #Else Display Guess
             #Check Clues
             #Check Counter 12
  end
  
  #Check Clues
    #Show Keys
    #Check D&P
    #Check DO

  #Check Counter 12
    #Call player instance Show Counter
    #If Counter variable equals 11, display warning final guess message
    #If Counter variable equals 12, display game over message

  #Check D&P (Correct Digit and Position)
    #If Player guess has any correct digits in correct index position of code array,
      #then return that number of D&P symbols
    
  #Check DO (Correct Digit Only)
    #If Player guess has any correct digits but in wrong index position of code array,
      #then return that number of DO symbols

  #Get Guess
    #Loop
      #Display prompt message to player for guess
      #Call player instance Take Guess
        #If true, assign to Current Guess Variable and break
        #Else, reprompt message

  def get_code
    current_code = @code.show_code
    p current_code
    #Call code instance Show Code
    #Set Show Code to Code Variable
  end

  #Check Guess (Code Variable, Current Guess Variable)
    #Check if Code Variable equals Current Guess Variable
  
  #Display Guess (Current Guess Variable)
    #Show color coded version of Current Guess Variable

end

class Code

  def initialize
    @secret_code = Array.new(4) { rand(1..6) }
  end
    
  def show_code
    @secret_code
  end

end

class Player
  attr_reader :current_guess, :guess_counter

  def initialize
    @guess_counter = 0
  end

  def take_guess
    loop do
      puts 'Guess the code! Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
      @current_guess = gets.chomp.each_char.map {|c| c.to_i}
      if check_valid
        @guess_counter += 1
        break
      else
        puts "That's not right!"
      end
    end
  end

  def check_valid
    @current_guess.all? { |i| i.is_a?(Integer) && i.between?(1, 6) } && @current_guess.length == 4
  end
end

mastermind = Game.new
mastermind.start_game
