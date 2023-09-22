# frozen_string_literal: true

require_relative 'frame'
require 'debug'

class Game
  def initialize(marks)
    @frames = []
    build_frame(marks)
    # binding.break
  end

  def build_frame(marks)
    tmp_frame_in_each_at_marks = []
    frame_number = 0

    marks.each do |mark|
      if mark == 'X' && frame_number != 9
        @frames << Frame.new(first_mark: mark, frame_number: frame_number)
        frame_number += 1
      elsif frame_number == 9
        tmp_frame_in_each_at_marks << mark
      else
        tmp_frame_in_each_at_marks << mark

        if tmp_frame_in_each_at_marks.length == 2
          @frames << Frame.new(
            first_mark: tmp_frame_in_each_at_marks[0],
            second_mark: tmp_frame_in_each_at_marks[1],
            frame_number: frame_number
          )
          frame_number += 1
          tmp_frame_in_each_at_marks = []
        end
      end
    end
    @frames << Frame.new(
      first_mark: tmp_frame_in_each_at_marks[0],
      second_mark: tmp_frame_in_each_at_marks[1],
      third_mark: tmp_frame_in_each_at_marks[2],
      frame_number: frame_number
    )
  end

  def calculate_score
    total_score = 0

    @frames.each.with_index do |_frame, frame_number|
      total_score += @frames[frame_number].score
    end

    @frames[0..8].each.with_index do |frame, frame_number|
      total_score += bonus_point(frame, frame_number)
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
