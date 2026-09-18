# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_NUM = 10

  def initialize(scores_input)
    shots = scores_input.split(',').map { |shot| Shot.new(shot) }
    @frames = []
    i = 0
    LAST_FRAME_NUM.times do |frame_num|
      size = if frame_num == LAST_FRAME_NUM - 1
               3
             else
               shots[i].strike? ? 1 : 2
             end
      @frames << Frame.new(shots[i, size])
      i += size
    end
  end

  def result
    @frames.each.with_index(1).sum do |frame, next_frame_num|
      following_frames = @frames[next_frame_num..]
      frame.score(following_frames)
    end
  end
end
