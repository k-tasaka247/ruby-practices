#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './ls_methods'

opt = OptionParser.new
options = {}
opt.on('-a', '--all') { |v| options[:a] = v }
opt.on('-r', '--reverse') { |v| options[:r] = v }
opt.on('-l') { |v| options[:l] = v }
opt.parse!(ARGV)

puts ls_print(options, ARGV[0] || '.')
