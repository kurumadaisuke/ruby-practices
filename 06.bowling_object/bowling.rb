# frozen_string_literal: true

require_relative 'game'

bowling_score = ARGV[0].split(',')
game = Game.new(bowling_score)
puts game.score_calculation
