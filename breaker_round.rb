# frozen_string_literal: true

# Creates a Code Breaker round with new code, new player, and loops through game
class BreakerRound < Game
  include GameLogic

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
  end

  def increase_counter
    @turn_counter += 1
  end

  def code
    @code.secret_code.slice(0..-1)
  end

  def begin_game_loop(current_code)
    loop do
      increase_counter
      current_guess = ask_player
      display_guess(current_guess, @turn_counter)
      display_clues(current_code, current_guess)
      break if correct_guess(current_code, current_guess)
      break if check_counter_12(current_code)
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

  def check_counter_12(current_code)
    if @turn_counter == 11
      puts 'WARNING: This is your final turn to guess.'
      puts
    elsif @turn_counter == 12
      color_code(current_code)
      puts
      puts 'Game over, you lose. Master. Minded.'
      puts
      true
    end
  end
end
