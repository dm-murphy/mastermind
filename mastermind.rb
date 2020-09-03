# Computer AI Logic
# Create set of all possible code combinations
# Make this into a new array of all possibilities
# Make first guess [1,1,2,2]
# Then once the computer receives the feedback, it eliminates from the original set
# all guesses that could not satisfy the combination of that guess and the given feedback.

# frozen_string_literal: true

# Set up of rules, keys and chooses which round to play
class Game

  def initialize
    show_rules
    show_keys
    choose_game
  end

  def show_rules
    puts <<-HEREDOC
    
    Welcome to Mastermind!

    You have 12 turns to break the code.

    For each turn, enter a 4 digit guess from the numbers 1 - 6.
    
    \e[41m 1 \e[0m \e[42m 2 \e[0m \e[43m 3 \e[0m \e[44m 4 \e[0m \e[45m 5 \e[0m \e[46m 6 \e[0m

    Numbers can be used more than once.

    For example:
    
    \e[41m 1 \e[0m \e[42m 2 \e[0m \e[42m 2 \e[0m \e[45m 5 \e[0m

    If you guess incorrectly, you will be given clues for your next guess.
    HEREDOC
  end

  def show_keys
    puts <<-HEREDOC

    Each \e[32m\!\e[0m means a correct number in a correct position.
    Each \e[91m\?\e[0m means a correct number but in the wrong position.
    If no symbols appear, there are no correct numbers.

    HEREDOC
  end

  def choose_game
    loop do
      puts "Would you like to be the Code Master (m) or Code Breaker (b)?"
      result = gets.chomp
      if result.downcase == 'm'
        puts
        new_master_round
        break
      elsif result.downcase == 'b'
        puts
        new_breaker_round
        break
      else
        puts "Come again?" 
      end
    end
  end

  def new_breaker_round
    @breaker_round = BreakerRound.new
  end

  def new_master_round
    @master_round = MasterRound.new
  end
end

# Creates a Code Breaker round with new code, new player, and loops through game
class BreakerRound < Game

  def initialize
    @code = Code.new
    @player = Player.new
    @turn_counter = 0
    start_game
  end

  def start_game
    puts 'May the odds be ever in your favor.'
    puts
    puts 'The Code Master has chosen a code.'
    puts
    current_code = code
    begin_game_loop(current_code)
    continue
  end

  def increase_counter
    @turn_counter += 1
  end

  def code
    @code.secret_code.slice(0..-1)
  end

  def begin_game_loop(current_code)
    puts "Debugging hint: the secret code is #{current_code}" # Keep for debugging and delete later
    loop do
      increase_counter
      current_guess = ask_player
      display_guess(current_guess, @turn_counter)
      display_clues(current_code, current_guess)
      #puts "Debugging hint: the original code should still be #{@code.secret_code}" # Keep for debugging and delete later
      break if correct_guess(current_code, current_guess)
      break if check_counter_12
    end
  end

  def ask_player
    @player.enter_code
    @player.inputted_code
  end

  def display_guess(current_guess, counter)
    puts
    puts "Guess Number #{counter}: "
    puts
    color_code(current_guess)
    puts
    puts
  end

  def color_code(code)
    color_key = { 
                   1 => "\e[41m 1 \e[0m ", #red
                   2 => "\e[42m 2 \e[0m ", #green
                   3 => "\e[43m 3 \e[0m ", #brown
                   4 => "\e[44m 4 \e[0m ", #blue
                   5 => "\e[45m 5 \e[0m ", #magenta
                   6 => "\e[46m 6 \e[0m "  #cyan
                 }
    code.each do |n|
      print color_key[n]
    end
  end

  def display_clues(current_code, current_guess)
    clue_code = current_code.slice(0..-1)
    clue_guess = current_guess.slice(0..-1)
    check_clues(clue_code, clue_guess)
    puts
    show_keys
  end

  def check_clues(clue_code, clue_guess)
    check_exclamations(clue_code, clue_guess)
    check_questions(clue_code, clue_guess)
  end

  def check_exclamations(clue_code, clue_guess)
    clue_guess.each_with_index.map do |guess_char, index|
      next unless clue_code[index] == guess_char

      print "\e[32m\!\e[0m " #Print green exclammation mark
      clue_code[index] = '!'
      clue_guess[index] = 'X'
    end
  end

  def check_questions(clue_code, clue_guess)
    clue_guess.each.map do |guess_char|
      if clue_code.include? guess_char
        print "\e[91m\?\e[0m " #Print red question mark
      end
    end
  end

  def correct_guess(current_code, current_guess)
    if check_guess(current_code, current_guess)
      puts 'Correct. Master. Mind.'
      puts
      true
    else
      puts 'Incorrect.'
      puts
    end
  end

  def check_guess(current_code, current_guess)
    current_code == current_guess
  end

  def check_counter_12
    if @turn_counter == 11
      puts 'WARNING: This is your final turn to guess.'
      puts
    elsif @turn_counter == 12
      puts 'Game over, you lose. Master. Minded.'
      puts
      true
    end
  end

  def continue
    puts 'Continue? Enter y to start a new game.'
    answer = gets.chomp
    if answer.downcase == 'y'
      puts
      puts "Let's play again."
      puts
      choose_game
    else
      puts 'Goodbye.'
    end
  end
end

# Generates random secret_code for the Code Breaker round
class Code
  attr_reader :secret_code

  def initialize
    @secret_code = Array.new(4) { rand(1..6) }
  end

end

# Creates human player and takes in guesses for the Code Breaker round
class Player
  attr_reader :inputted_code

  def enter_code
    loop do
      puts 'Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
      @inputted_code = gets.chomp.each_char.map { |c| c.to_i }
      break if check_valid

      puts "That's not valid."
    end
  end

  def check_valid
    @inputted_code.all? { |i| i.is_a?(Integer) && i.between?(1, 6) } && @inputted_code.length == 4
  end
end

class MasterRound < BreakerRound
  
  def initialize
    @player = Player.new
    @player_code = ask_player
    start_master
  end

  def start_master
    show_player_code
    start_computer_turn
    continue
  end

  def show_player_code
    puts
    color_code(@player_code)
    puts
  end

  def start_computer_turn
    puts 'The computer will now try to break your code...'
    puts
    guess_counter = 0
    loop do
      computer_guess = take_guess
      guess_counter += 1
      display_guess(computer_guess, guess_counter)
      display_clues(@player_code, computer_guess)
      sleep(2)
      if computer_guess == @player_code
        puts 'Game over. The computer broke the code.'
        break
      elsif guess_counter == 12
        puts 'You win! The computer failed to break the code.'
        break
      end
    end
  end

  def take_guess
    Array.new(4) { rand(1..6) }
  end

  def take_better_guess
    Array.new(4) 
  end


end

Game.new
