# frozen_string_literal: true

require_relative 'entry'

class Directory
  attr_reader :entries

  def initialize(path, all:, reverse:)
    entry_names = if all
                    Dir.entries(path)
                  else
                    Dir.glob('*', base: path)
                  end
    fixed_entry_names = entry_names.sort.map { |name| Entry.new(path, name) }
    @entries = reverse ? fixed_entry_names.reverse : fixed_entry_names
  end

  def block_total
    @entries.sum(&:block_size)
  end
end
