# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_NUM = 10

  def initialize(scores_input)
    scores = scores_input.split(',').map { |score| Shot.new(score) }
    @frames = []
    i = 0
    until @frames.size == LAST_FRAME_NUM
      if @frames.size == LAST_FRAME_NUM - 1
        @frames << Frame.new(scores[i..], last: true)
      elsif scores[i].strike?
        @frames << Frame.new([scores[i]])
        i += 1
      else
        @frames << Frame.new(scores[i, 2])
        i += 2
      end
    end
  end

  def result
    @frames.each_index.sum { |frame_num| frame_score(frame_num) }
  end

  private

  def frame_score(frame_num)
    frame = @frames[frame_num]
    score = frame.pins_sum
    return score unless frame.bonus?

    next_frame = @frames[frame_num + 1]
    score += next_frame.shots[0].score
    return score if frame.spare?

    score + if next_frame.second_shot?
              next_frame.shots[1].score
            else
              @frames[frame_num + 2].shots[0].score
            end
  end
end
