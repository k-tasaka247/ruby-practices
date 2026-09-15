# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_NUM = 9
  STRIKE_CHAR = 'X'
  attr_reader :frames

  def initialize(scores_input)
    scores = scores_input.split(',')
    scores_chunked = scores.chunk { |score| score == STRIKE_CHAR }.map(&:last)
    scores_sliced = scores_chunked.map do |chunk|
      chunk[0] == STRIKE_CHAR ? chunk.map { ['10'] } : chunk.each_slice(2).to_a
    end.flatten(1)
    @frames = (0..LAST_FRAME_NUM).map do |i|
      frame = (i == LAST_FRAME_NUM ? scores_sliced[i, 3].flatten : scores_sliced[i])
      Frame.new(frame, i, LAST_FRAME_NUM)
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
