#Problem is I am changing my instance variable for the secret_code and while I want to do that to run the secondary check on ?, I don't want it to stay that way
#outside those specific methods. So I want to learn how scope works in this scenario and if I should be using something instead of an instance variable set to a new 
#variable, or if I should be locking down certain methods as private.

class Game

  def initialize
    @player = Player.new
    @code = Code.new
  end

  def show_rules
    puts <<-HEREDOC
    
    Welcome to Mastermind!

    You have 12 turns to break the computer's code. 
    
    For each turn, enter a 4 digit guess choosing from the numbers 1 - 6. 
    
    A number can be used more than once.

    If you guess incorrectly, you will be given clues to help with
    your next guess.

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
    current_code = get_code
    puts "Debugging hint: the secret code is #{current_code}" # Keep for debugging and delete later
    loop do
      current_guess = get_guess
      if check_guess(current_code, current_guess)
        puts "You win. You are the master now!"
        break
      else
        puts "Wrong!"
        p current_guess
        check_clues(current_code, current_guess)
        break if check_counter_12
      end
      puts "Debugging hint: the original code should still be #{@code.secret_code}" # Keep for debugging and delete later
    end
  end

  def check_counter_12
    if @player.guess_counter == 11
      puts "Warning, this is your final turn to guess!"
    elsif @player.guess_counter == 12
      puts "Game over, you lose!"
      true
    end
  end

  def get_guess
    puts 'Guess the code! Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
    @player.take_guess
    @player.current_guess
  end

  def get_code
    @code.secret_code
  end

  def check_guess(code, guess)
    code == guess
  end
  
  def check_clues(code, guess)
    show_keys
    test_check_exclamations(code, guess)
    test_check_questions(code, guess)
    #check_digit_position(code, guess)
    #check_digit_only(code, guess)
  end

  def test_check_exclamations(code, guess)
    guess.each_with_index.map do |guess_char, index|
      if code[index] == guess_char
        print "!"
        code[index] = "!"
      end
      puts
    end
  end

  def test_check_questions(code, guess)
    guess.each_with_index.map do |guess_char, index|
      if code.include? guess_char
        print "?"
      end
      puts
    end
  end

  #def check_digit_position(code, guess)
    #guess.each_with_index.map do |guess_char, index|
      #if code[index] == guess_char
        #print "!"
      #end
      #puts
    #end
  #end
  
  #def check_digit_only(code, guess)
    #guess.each_with_index.map do |guess_char, index|
      #if (code[index] != guess_char) && (code.include? guess_char)
        #puts "?"
      #end
      #puts
    #end
  #end
end

class Code
  attr_reader :secret_code

  def initialize
    @secret_code = Array.new(4) { rand(1..6) }
  end
end

class Player
  attr_reader :current_guess, :guess_counter

  def initialize
    @guess_counter = 0
  end

  def take_guess
    loop do
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
