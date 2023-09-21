# frozen_string_literal: true

require_relative 'game'

# 最後のスコアと下記スコアと一緒に見えてしまう。 配列の要素の名前mark読んでいる marksでいいんじゃないのか？ 物とか概念に複数形になる s 誰でも一目でわかることが大事
bowling_score = ARGV[0].split(',')
game = Game.new(bowling_score)
puts game.calculate_score
