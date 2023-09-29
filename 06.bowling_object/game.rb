# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks)
    @frames = build_frame(marks)
  end

  def build_frame(marks)
    tmp_frame = []
    frames = []

    count_frame_number = 0

    marks.each do |mark|
      if count_frame_number == 9
        tmp_frame << mark
      elsif mark == 'X'
        frames << Frame.new(frame_number: count_frame_number, first_mark: mark)
        count_frame_number += 1
      else
        tmp_frame << mark
        if tmp_frame.length == 2
          frames << Frame.new(frame_number: count_frame_number, first_mark: tmp_frame[0], second_mark: tmp_frame[1])
          count_frame_number += 1
          tmp_frame = []
        end
      end
    end
    frames << Frame.new(frame_number: count_frame_number, first_mark: tmp_frame[0], second_mark: tmp_frame[1], third_mark: tmp_frame[2])
  end

  def calculate_score
    total_score = 0

    @frames.each.with_index do |frame, frame_number|
      total_score += @frames[frame_number].score
      total_score += calculate_bonus_point(frame, frame_number) if frame_number != 9
    end

    total_score
  end

  def calculate_bonus_point(frame, frame_number)
    next_frame = @frames[frame_number + 1]

    if frame.strike? && next_frame.strike? && frame.until_nine?
      two_next_frame = @frames[frame_number + 2]
      next_frame.first_shot.score + two_next_frame.first_shot.score
    elsif frame.strike?
      next_frame.first_shot.score + next_frame.second_shot.score
    elsif frame.spare?
      next_frame.first_shot.score
    else
      0
    end
  end
end
