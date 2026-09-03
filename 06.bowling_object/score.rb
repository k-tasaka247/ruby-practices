# frozen_string_literal: true

class Score
  # attr_reader :score

  def initialize(game)
    @game = game.arranged # フレームごとに分割したスコアたち
    @score = 0
  end

  def result(score_system = 'old')
    @score = (score_system == 'current' ? current_frame_score_calcurate(@game) : old_rule_score_calculate(@game))
  end

  private

  def old_rule_score_calculate(game)
    game.each_with_index do |frame, i|
      break if i > 9

      @score += frame.sum
      next if frame.sum != 10

      @score += game[i + 1][0]
      next if frame[0] != 10

      @score += if game[i + 1][0] == 10
                  game[i + 2][0]
                else
                  game[i + 1][1]
                end
    end
    @score
  end

  def current_frame_score_calcurate(game)
    game.each do |frame|
      @score += frame.sum
      next if frame.sum != 10

      @score += if frame[0] == 10
                  20
                else
                  frame[0]
                end
    end
    @score
  end
end
