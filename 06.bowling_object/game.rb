# frozen_string_literal: true

require_relative 'frame'

class Game
  LAST_FRAME_NUM = 10
  attr_reader :game_data

  def initialize(scores)
    @game = scores.split(',')
    @game_data = []
    LAST_FRAME_NUM.times { |i| @game_data << Frame.new(@game, i) }
  end

  def frame_score(frame_num)
    frame = @game_data[frame_num]
    score = frame.pins_sum
    return score if frame_num == 9 || (!frame.strike? && !frame.spare?)

    score += @game_data[frame_num + 1].first_shot.score
    return score if frame.spare?

    score + if @game_data[frame_num + 1].second_shot.nil?
              @game_data[frame_num + 2].first_shot.score
            else
              @game_data[frame_num + 1].second_shot.score
            end
  end

  def result
    (0...LAST_FRAME_NUM).map { |i| frame_score(i) }.sum
  end
end
