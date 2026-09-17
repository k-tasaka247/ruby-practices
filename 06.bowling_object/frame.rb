# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :shots

  def initialize(shots, last: false)
    @shots = shots
    @last = last
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

  private

  def last_frame?
    @last
  end
end
