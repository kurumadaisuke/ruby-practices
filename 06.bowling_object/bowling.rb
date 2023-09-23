# frozen_string_literal: true

require_relative 'game'

marks = ARGV[0].split(',')
game = Game.new(marks)
puts game.calculate_score
