# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :first_shot, :second_shot, :third_shot

  def initialize(scores, frame_num)
    @first_shot = Shot.new(scores)
    @second_shot = Shot.new(scores) if frame_num == 9 || @first_shot.score != 10
    @third_shot = Shot.new(scores) if frame_num == 9 && !scores.nil?
  end

  def strike?
    @first_shot.score == 10
  end

  def spare?
    return false if strike?

    @first_shot.score + @second_shot.score == 10
  end

  def pins_sum
    sum = @first_shot.score
    sum += @second_shot.score unless @second_shot.nil?
    sum += @third_shot.score unless @third_shot.nil?
    sum
  end
end
