#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative 'frame'
require_relative 'game'
require_relative 'score'

game = Game.new(ARGV[0]) # ゲームの登録
score = Score.new(game) # スコア計算準備

puts score.result # スコア出力（新ルールで計算するには引数に'current'を指定する）
