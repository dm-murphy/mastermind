# frozen_string_literal: true

# Contains Mastermind game rules and round creation
class Game

  def play_game
    loop do
      show_rules
      show_keys
      choose_game
      break unless continue?
    end
    puts 'Goodbye.'
  end

  def show_rules
    puts <<-HEREDOC
    
    Welcome to Mastermind!

    You have 12 turns to break the code.

    For each turn, enter a 4 digit guess from the numbers 1 - 6.
    
    \e[41m 1 \e[0m \e[42m 2 \e[0m \e[43m 3 \e[0m \e[44m 4 \e[0m \e[45m 5 \e[0m \e[46m 6 \e[0m

    Numbers can be used more than once.

    For example:
    
    \e[41m 1 \e[0m \e[43m 3 \e[0m \e[43m 3 \e[0m \e[45m 5 \e[0m

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
    @breaker_round.start_breaker
  end

  def new_master_round
    @master_round = MasterRound.new
    @master_round.start_master
  end

  def continue?
    puts 'Continue? Enter y to start a new game.'
    answer = gets.chomp
    answer.downcase == 'y'
  end
end
