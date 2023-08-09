require_relative 'frame'
require 'debug'

class Game
  def initialize(shots)
    @shots = shots
    @game = []
  end

  def score
    @frames = build_frames
    total_score = 0

    @frames.each.with_index do |frame, i|
      @game << Frame.new(frame[0], frame[1], frame[2])
      total_score += @game[i].score
      i + 1
    end

    @game[0..8].each.with_index do |frame, i|
      total_score += bonus_point(frame, i)
    end

    total_score
  end

  def build_frames
    frame = []
    frames = []
    @shots.each do |shot|
      if shot == 'X'
        frames << [shot.dup]
      else
        frame << shot.dup
          if frame.length == 2
            frames << frame
            frame = []
          end
      end
    end

    if frame.length == 1
      frames << frame
    end

    if frames.length >= 10
      frames[9] += frames[10..].flatten
      frames = frames.take(10)
    end
    frames
  end

  def bonus_point(frame, i)
    next_frame = @game[i + 1]
    if frame.strike?
      if next_frame.strike? && i != 8
        two_next_frame = @game[i + 2]
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
