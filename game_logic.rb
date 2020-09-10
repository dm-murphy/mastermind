# frozen_string_literal: true


# Game logic color codes and logic
module GameLogic
  
  def ask_player
    @player.enter_code
    @player.inputted_code
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

  def display_guess(guess, counter)
    puts
    puts "Guess Number #{counter}: "
    puts
    color_code(guess)
    puts
    puts
  end

  def display_clues(code, guess)
    check_clues(code, guess)
    @exact_matches.times { print "\e[32m\!\e[0m " } #Print green exclammation mark
    @number_matches.times { print "\e[91m\?\e[0m " } #Print red question mark
    puts
    show_keys
  end

  def check_clues(code, guess)
    check_code = code.slice(0..-1)
    check_guess = guess.slice(0..-1)
    check_exclamations(check_code, check_guess)
    check_questions(check_code, check_guess)
  end

  def check_exclamations(code, guess)
    @exact_matches = 0
    guess.each_with_index.map do |guess_char, index|
      next unless code[index] == guess_char

      @exact_matches += 1
      code[index] = '!'
      guess[index] = 'X'
    end
  end

  def check_questions(code, guess)
    @number_matches = 0
    guess.each.map do |guess_char|
      @number_matches += 1 if code.include? guess_char
    end
  end
end
