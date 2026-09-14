# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot, :frame_num

  def initialize(scores, frame_num)
    @shots = []
    @frame_num = frame_num
    @shots << Shot.new(scores[0])
    @shots << Shot.new(scores[1]) if last_frame? || !strike?
    @shots << Shot.new(scores[2]) if last_frame? && !scores.nil?
    @first_shot = @shots[0]
    @second_shot = @shots[1]
    @third_shot = @shots[2]
  end

  def last_frame?
    @frame_num == 9
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @first_shot.score + @second_shot.score == 10
  end

  def pins_sum
    @shots.sum(&:score)
  end
end
