# frozen_string_literal: true

require_relative 'frame'
require 'debug'
        # binding.break
        
class Game
  def initialize(bowling_score)
    @frames = []
    @frames = mold_frame(bowling_score)
    @frames.each.with_index do |f, frame_number|
      @frames[frame_number] = Frame.new(f[0], f[1], f[2], frame_number)
    end
  end

  def mold_frame(bowling_score)
    frame = []
    
    bowling_score.each do |shot|
      if shot == 'X'
        @frames << [shot.dup]
      else
        frame << shot.dup
        if frame.length == 2
          @frames << frame
          frame = []
        end
      end
    end

    @frames << frame if frame.length == 1
    @frames[9] += @frames[10..].flatten if @frames.length >= 10
    @frames.take(10)
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
