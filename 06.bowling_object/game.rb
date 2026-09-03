# frozen_string_literal: true

class Game
  attr_reader :arranged

  def initialize(scores, pins = 10)
    @pins = pins # ピンの本数
    game_str = scores.gsub(/X/, "#{pins},0").split(',') # スコアの解析（Xの変換目的）
    @game = game_str.map(&:to_i) # 整数型への変換
    @arranged = Frame.new(@game).frames # Frameクラスの生成、フレームごとに分割
  end
end
