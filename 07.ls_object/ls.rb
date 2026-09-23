#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'command'

opt = OptionParser.new
options = {}
opt.on('-a', '--all') { |v| options[:all] = v }
opt.on('-r', '--reverse') { |v| options[:reverse] = v }
opt.on('-l') { |v| options[:long_format] = v }
opt.parse!(ARGV)

ls = Command.new(ARGV[0] || '.', options)
ls.display
