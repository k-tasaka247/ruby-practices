#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require_relative 'wc_methods'

opt = OptionParser.new
options = {}
opt.on('-c', '--bytes') { |v| options[:c] = v }
opt.on('-w', '--chars') { |v| options[:w] = v }
opt.on('-l', '--lines') { |v| options[:l] = v }
opt.parse!(ARGV)

if ARGV.empty?
  lines = $stdin.readlines
  puts wc_stdout_output(lines.join, options)
else
  puts multiple?(ARGV) ? wc_multiple_output(ARGV, options) : wc_output(ARGV[0], options)
end
