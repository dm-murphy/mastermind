# frozen_string_literal: true

require_relative 'game.rb'
require_relative 'game_logic.rb'
require_relative 'breaker_round.rb'
require_relative 'code.rb'
require_relative 'player.rb'
require_relative 'master_round.rb'

Game.new.play_game
