#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'score'

game = Game.new(ARGV[0]) # ゲームの登録

puts game.result
