# frozen_string_literal: true

# Creates a Code Master round with computer guessing logic
class MasterRound < Game
  include GameLogic
  
  def initialize  
    @possible_candidates = [1, 2, 3, 4, 5, 6].repeated_permutation(4).to_a
    @remaining_candidates = @possible_candidates.slice(0..-1)  
    @player = Player.new
    @player_code = ask_player
    @exact_matches = 0
    @number_matches = 0
  end

  def start_master
    show_player_code
    puts
    puts 'The computer will now try to break your code...'
    puts
    start_computer_turn
  end

  def show_player_code
    puts
    color_code(@player_code)
    puts
  end

  def start_computer_turn
    guess_counter = 0
    last_guess = [0, 0, 0, 0]
    loop do
      computer_guess = take_guess(guess_counter, last_guess)
      guess_counter += 1
      update_board(computer_guess, guess_counter)
      break if winner_check?(computer_guess, guess_counter)

      last_guess = computer_guess.slice(0..-1)
    end
  end

  def update_board(computer_guess, guess_counter)
    display_guess(computer_guess, guess_counter)
    display_clues(@player_code, computer_guess)
    sleep(2)
  end

  def winner_check?(computer_guess, guess_counter)
    if computer_guess == @player_code
      puts 'Game over. The computer broke the code.'
      true
    elsif guess_counter == 12
      puts 'You win! The computer failed to break the code.'
      true
    end
  end

  def take_guess(guess_counter, last_guess)
    if guess_counter.zero?
      then [1, 1, 2, 2]
    else
      candidate_checker(last_guess)
      @remaining_candidates.first
    end
  end

  def candidate_checker(last_guess)
    @possible_candidates.each do |candidate|
      compare_feedback(candidate, last_guess)
    end
  end

  def compare_feedback(candidate, last_guess)
    feedback_candidate = candidate.slice(0..-1)
    feedback_guess = last_guess.slice(0..-1)

    check_clues(@player_code, last_guess)
    last_feedback = [@exact_matches, @number_matches]

    check_clues(feedback_candidate, feedback_guess)
    test_feedback = [@exact_matches, @number_matches]

    @remaining_candidates.delete(candidate) unless last_feedback == test_feedback
    @remaining_candidates.delete(last_guess)
  end
end
