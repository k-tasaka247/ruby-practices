# frozen_string_literal: true

require_relative 'directory'
require_relative 'column_formatter'
require_relative 'long_formatter'

class Command
  def initialize(path, options)
    @path = path
    @options = options
  end

  def display
    directory = Directory.new(@path, all: @options[:all], reverse: @options[:reverse])
    directory_formatted = (@options[:long_format] ? LongFormatter.new(directory) : ColumnFormatter.new(directory))
    puts directory_formatted.output
  end
end
