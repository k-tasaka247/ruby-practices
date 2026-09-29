# frozen_string_literal: true

require_relative 'entry'

class Directory
  attr_reader :entries

  def initialize(path, all:, reverse:)
    @path = path
    @entries = if all
                 Dir.entries(path).sort.map { |entry| Entry.new(@path, entry) }
               else
                 Dir.glob('*', base: @path).sort.map { |entry| Entry.new(@path, entry) }
               end
    @entries.reverse! if reverse
  end

  def block_total
    @entries.sum(&:block_size)
  end
end
