# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots, :frame_num

  def initialize(scores, frame_num, last_frame_num)
    @shots = []
    @frame_num = frame_num
    @last_frame_num = last_frame_num
    scores.map { |score| @shots << Shot.new(score) }
  end

  def last_frame?
    @frame_num == @last_frame_num
  end

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots[0].score + @shots[1].score == 10
  end

  def pins_sum
    @shots.sum(&:score)
  end

  def bonus?
    !last_frame? && (strike? || spare?)
  end

  def second_shot?
    last_frame? || !strike?
  end
end
