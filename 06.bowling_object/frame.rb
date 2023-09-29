# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_accessor :first_shot, :second_shot

  def initialize(frame_number:, first_mark:, second_mark: nil, third_mark: nil)
    @frame_number = frame_number
    @first_shot = Shot.new(first_mark)
    @second_shot = Shot.new(second_mark)
    @third_shot = Shot.new(third_mark)
  end

  def score
    [
      @first_shot.score,
      @second_shot.score,
      @third_shot.score
    ].sum
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    @first_shot.score != 10 && score == 10
  end

  def until_nine?
    @frame_number < 8
  end
end
