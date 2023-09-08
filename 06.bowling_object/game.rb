# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(bowling_score)
    @bowling_score = bowling_score
    @frames = []
  end

  def calculate_score
    @new_frames = build_frames
    total_score = 0

    @new_frames.each.with_index do |_frame, frame_number|
      total_score += @frames[frame_number].score
    end

    @frames[0..8].each.with_index do |frame, i|
      total_score += bonus_point(frame, i)
    end

    total_score
  end

  def build_frames
    frame = []
    frame_list = []

    @bowling_score.each do |shot|
      if shot == 'X'
        frame_list << [shot.dup]
      else
        frame << shot.dup
        if frame.length == 2
          frame_list << frame
          frame = []
        end
      end
    end

    frame_list << frame if frame.length == 1
    frame_list[9] += frame_list[10..].flatten if frame_list.length >= 10

    frame_list = frame_list.take(10)
    frame_list.each.with_index do |f, frame_number|
      @frames << Frame.new(f[0], f[1], f[2], frame_number)
    end

    frame_list
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
