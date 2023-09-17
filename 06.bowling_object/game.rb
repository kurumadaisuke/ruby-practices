# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  def initialize(bowling_score)
    @frames = build_frame(bowling_score)
      # binding.break
  end

  def build_frame(bowling_score)
    frame = []
    tmp_frames = []

    bowling_score.map.with_index do |mark, frame_number|
      if mark == 'X'
        tmp_frames << [mark.dup]
      else
        frame << mark.dup
        if frame.length == 2
          tmp_frames << frame
          frame = []
        end
      end
    end

    tmp_frames << frame if frame.length == 1
    tmp_frames[9] += tmp_frames[10..].flatten if tmp_frames.length >= 10

    tmp_frames.take(10).map.with_index do |mark, frame_number|
      Frame.new(mark[0],mark[1], mark[2], frame_number)
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
