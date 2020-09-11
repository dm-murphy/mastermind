# frozen_string_literal: true

# Creates human player and takes in guesses
class Player
  attr_reader :inputted_code

  def initialize
    @inputted_code = []
  end


  def enter_code
    loop do
      puts 'Enter 4 numbers between 1 - 6. Do not use spaces or commas. E.g. 1234'
      @inputted_code = gets.chomp.each_char.map { |c| c.to_i }
      break if check_valid?

      puts "That's not valid."
    end
  end

  def check_valid?
    @inputted_code.all? { |i| i.is_a?(Integer) && i.between?(1, 6) } && @inputted_code.length == 4
  end
end
