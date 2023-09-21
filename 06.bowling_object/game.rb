# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  # marksにした方がわかりやすい
  def initialize(bowling_score)
    @frames = build_frame(bowling_score)
      # binding.break
  end

  def build_frame(bowling_score)
    # 最初からFrameクラスを定義すれば良いのでは？
    tmp_frame = []

    # 気を抜くと変数がより一層大事な言語がRuby メソッドしばらく経った後に変数名を書き直したりする
    # shotsではなく、複数入っている配列でないとおかしい。 何をshotと呼ぶかについて⇨すでにshotクラスが定義されているので違う 他でmarkとして認識されている 他の場所で名前が変わっている markは必須
    # 配列の要素数が違うものに対してmapを使うの使い方が間違っている。 mapを使う＝配列要素数が一緒と
    tmp_frames = bowling_score.map do |shots|
      if shots == 'X'
        Frame.new(shot, nil, nil, frame_number)
      else
        tmp_frame << shots
        if tmp_frame.length == 2
          result = tmp_frame
          tmp_frame = []
          result
        end
      end
    end.compact!
    # compact!やめる
    # if?? unless?? frame_number10になったらゴニョゴニョする処理を書くといい
    # 2回ループは意図が分かりづらい 2回のループの意図も考えることも大事 いらなければ無くす

    binding.break
    tmp_frames << tmp_frame if tmp_frame.length == 1
    tmp_frames[9] += tmp_frames[10..].flatten if tmp_frames.length >= 10

    # tmp_frames のmarkではない
    # markが入った配列がmarkになっている 他の人に編集することを考えると 実際には配列が入っているので後のバグに繋がる
    tmp_frames.take(10).map.with_index do |mark, frame_number| 
      Frame.new(mark[0], mark[1], mark[2], frame_number)
    end
  end

  def calculate_score
    total_score = 0

    @frames.each.with_index do |_frame, frame_number|
      total_score += @frames[frame_number].score
    end

    @frames[0..8].each.with_index do |frame, i|
      total_score += bonus_point(frame, i)
    end

    total_score
  end

  def bonus_point(frame, frame_number)
    next_frame = @frames[frame_number + 1]
    if frame.strike?
      if next_frame.strike? && frame.until_nine?
        two_next_frame = @frames[frame_number + 2]
        next_frame.first_shot.score + two_next_frame.first_shot.score
      else
        next_frame.first_shot.score + next_frame.second_shot.score
      end
    elsif frame.spare?
      next_frame.first_shot.score
    else
      0
    end
  end
end
