# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_NUM = 9
  attr_reader :frames

  def initialize(scores_input)
    scores = scores_input.split(',')
    scores_chunked = scores.chunk { |i| i == 'X' }.map { |j| j[1] }
    scores_sliced = scores_chunked.map { |k| k[0] == 'X' ? k.each_slice(1).to_a : k.each_slice(2).to_a }.flatten(1)
    @frames = (0..LAST_FRAME_NUM).map { |i| i == LAST_FRAME_NUM ? Frame.new(scores_sliced[i, 3].flatten, i) : Frame.new(scores_sliced[i], i) }
  end

  def result
    (0..LAST_FRAME_NUM).sum { |i| frame_score(i) }
  end

  private

  def frame_score(frame_num)
    frame = @frames[frame_num]
    score = frame.pins_sum
    return score if frame_num == LAST_FRAME_NUM || (!frame.strike? && !frame.spare?)

    next_frame = @frames[frame_num + 1]
    score += next_frame.first_shot.score
    return score if frame.spare?

    score + if next_frame.strike? && !next_frame.last_frame?
              @frames[frame_num + 2].first_shot.score
            else
              next_frame.second_shot.score
            end
  end
end
