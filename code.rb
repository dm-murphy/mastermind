# frozen_string_literal: true

# Generates random secret_code for the Code Breaker round
class Code
  attr_reader :secret_code

  def initialize
    @secret_code = Array.new(4) { rand(1..6) }
  end
end
