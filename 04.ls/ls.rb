#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative './ls_methods'

opt = OptionParser.new
options = {}
opt.on('-a') { |v| options[:a] = v }
opt.parse!(ARGV)

puts ls_print(options, ARGV[0])
