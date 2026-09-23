# frozen_string_literal: true

require_relative 'directory'
require_relative 'columnformatter'
require_relative 'longformatter'

class Command
  def initialize(path, options)
    @path = path
    @options = options
  end

  def display
    directory = make_directory_obj
    puts (@options[:long_format] ? LongFormatter.new(directory) : ColumnFormatter.new(directory)).output
  end

  private

  def make_directory_obj
    directory = Directory.new(@path)
    directory = directory.all if @options[:all]
    directory.reverse! if @options[:reverse]
    directory
  end
end
