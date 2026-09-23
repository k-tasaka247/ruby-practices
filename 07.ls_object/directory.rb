# frozen_string_literal: true

require_relative 'entry'

class Directory
  LONGFORMAT_COL_WITHOUT_FILE_NAME = 7

  attr_reader :entries

  def initialize(path)
    @path = path
    @entries = Dir.glob('*', base: @path).sort.map { |entry| Entry.new(@path, entry) }
  end

  def all
    hidden_entries = Dir.foreach(@path).select { |i| i.match(/^\..*/) }
    hidden_entries_sorted = hidden_entries.sort.map { |entry| Entry.new(@path, entry) }
    @entries.unshift(hidden_entries_sorted).flatten!
    self
  end

  def reverse!
    @entries.reverse!
    self
  end

  def block_total
    @entries.sum(&:block_size)
  end
end
