# frozen_string_literal: true

class Shot
  attr_reader :score

  def initialize(score_str)
    @score = score_str.to_i
  end
end
