#2 types of rounds
#Codebreaker Round
#Codemaster Round
#They could inherit the methods of the Round class
#Would Game class launch the New Codebreaker Round or the New Codemaster Round?
#Or should Game launch Round and then Round launch either Codebreaker or Codemaster



# frozen_string_literal: true

# Set up of rules, keys and rounds
class Game

  def initialize
    show_rules
    show_keys
    new_round
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

    Each \e[32m\!\e[0m means you guessed a correct number in a correct position.
    Each \e[91m\?\e[0m means you guessed a correct number but in the wrong position.
    If no symbols appear, you didn't guess any correct numbers.

    HEREDOC
  end

  def new_round
    @round = Round.new
  end
end

# Creates new code, new player, and loops through game
class Round < Game

  def initialize
    @code = Code.new
    @player = Player.new
    start_game
  end

  def start_game
    puts 'May the odds be ever in your favor.'
    puts
    current_code = code
    begin_game_loop(current_code)
    continue
  end

  def code
    @code.secret_code.slice(0..-1)
  end

  def begin_game_loop(current_code)
    puts "Debugging hint: the secret code is #{current_code}" # Keep for debugging and delete later
    loop do
      current_guess = guess
      display_guess(current_guess)
      display_clues(current_code, current_guess)
      #puts "Debugging hint: the original code should still be #{@code.secret_code}" # Keep for debugging and delete later
      break if correct_guess(current_code, current_guess)
      break if check_counter_12
    end
  end

  def guess
    puts 'Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
    @player.take_guess
    @player.current_guess
  end

  def display_guess(current_guess)
    puts
    puts "Guess Number #{@player.guess_counter}: "
    puts
    color_guess(current_guess)
    puts
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
    if @player.guess_counter == 11
      puts 'WARNING: This is your final turn to guess.'
      puts
    elsif @player.guess_counter == 12
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
      new_round
    else
      puts 'Goodbye.'
    end
  end
end

# Generates random secret_code for the round
class Code
  attr_reader :secret_code

  def initialize
    @secret_code = Array.new(4) { rand(1..6) }
  end
end

# Creates human player and takes in guesses
class Player
  attr_reader :current_guess, :guess_counter

  def initialize
    @guess_counter = 0
  end

  def take_guess
    loop do
      @current_guess = gets.chomp.each_char.map { |c| c.to_i }
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

Game.new
