
class Game

  def initialize
    @player = Player.new
    @code = Code.new
  end

  def show_rules
    puts <<-HEREDOC
    
    Welcome to Mastermind!

    May the odds be ever in your favor.

    You have 12 turns to break the code.

    For each turn, enter a 4 digit guess from the numbers 1 - 6.
    
    \e[41m 1 \e[0m \e[42m 2 \e[0m \e[43m 3 \e[0m \e[44m 4 \e[0m \e[45m 5 \e[0m \e[46m 6 \e[0m

    Numbers can be used more than once.

    If you guess incorrectly, you will be given clues for your next guess.
    HEREDOC
  end
  
  def show_keys
    puts <<-HEREDOC

    Each \e[32m\!\e[0m means you guessed a correct number in a correct position.
    Each \e[91m\?\e[0m means you guessed a correct number but in the wrong position.
    If no symbols appear, you didn't guess any correct numbers.

    HEREDOC
  end
  
  def start_game
    show_rules
    show_keys
    current_code = get_code
    #puts "Debugging hint: the secret code is #{current_code}" # Keep for debugging and delete later
    loop do
      current_guess = get_guess
      display_guess(current_guess)
      if check_guess(current_code, current_guess)
        puts "Correct. Master. Mind."
        break
      else
        puts "Incorrect."
        clue_code = current_code.slice(0..-1)
        check_clues(clue_code, current_guess)
        break if check_counter_12
      end
      #puts "Debugging hint: the original code should still be #{@code.secret_code}" # Keep for debugging and delete later
    end
  end

  def check_counter_12
    if @player.guess_counter == 11
      puts "WARNING: This is your final turn to guess."
    elsif @player.guess_counter == 12
      puts "Game over, you lose. Master. Minded."
      true
    end
  end

  def get_guess
    puts 'Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
    @player.take_guess
    @player.current_guess
  end

  def get_code
    @code.secret_code.slice(0..-1)
  end

  def check_guess(code, guess)
    code == guess
  end
  
  def check_clues(code, guess)
    check_exclamations(code, guess)
    check_questions(code, guess)
    puts
    show_keys
  end

  def check_exclamations(code, guess)
    guess.each_with_index.map do |guess_char, index|
      if code[index] == guess_char
        print "\e[32m\!\e[0m " #Print green exclammation mark
        code[index] = "!"
        guess[index] = "X"
      end
    end
  end

  def check_questions(code, guess)
    guess.each_with_index.map do |guess_char, index|
      if code.include? guess_char
        print "\e[91m\?\e[0m " #Print red question mark
      end
    end
  end

  def display_guess(current_guess)
    puts "Guess Number #{@player.guess_counter}: "
    puts
    color_guess(current_guess)
    puts
  end

  def color_guess(current_guess)
    color_code = { 
                   1 => "\e[41m 1 \e[0m ", #red
                   2 => "\e[42m 2 \e[0m ", #green
                   3 => "\e[43m 3 \e[0m ", #brown
                   4 => "\e[44m 4 \e[0m ", #blue
                   5 => "\e[45m 5 \e[0m ", #magenta
                   6 => "\e[46m 6 \e[0m "  #cyan
                 }
    current_guess.each do |n|
      print color_code[n]
    end
  end
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
