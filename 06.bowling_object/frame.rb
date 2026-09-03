# frozen_string_literal: true

class Frame
  attr_reader :frames

  def initialize(scores)
    @frames = scores.each_slice(2).to_a # スコアの配列をフレームに分割
  end
end
