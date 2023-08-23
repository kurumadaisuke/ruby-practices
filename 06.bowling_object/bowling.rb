# frozen_string_literal: true

require_relative 'game'
require 'debug'

shots = ARGV[0].split(',')
game = Game.new(shots)
puts game.score
