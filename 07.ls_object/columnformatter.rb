# frozen_string_literal: true

require_relative 'entry'
require_relative 'directory'

class ColumnFormatter
  MAX_COLS = 3

  def initialize(directory)
    @directory = directory
  end

  def output
    make_rows(@directory.entries).map { |row| row.join('  ') }
  end

  private

  def count_rows(entries)
    (entries.size / MAX_COLS.to_f).ceil
  end

  def make_cols(entries)
    col_group = []
    row_size = count_rows(entries)
    MAX_COLS.times do |i|
      index = row_size * i
      col_group << entries.values_at((index)...(index + row_size))
    end
    col_max_lengths = col_group.map { |entries_col| entries_col.compact.map(&:length).max }
    col_group.map.with_index do |col, i|
      col.map { |entry| entry ? entry.justify(col_max_lengths[i]) : entry }
    end
  end

  def make_rows(entries)
    make_cols(entries).transpose.compact
  end
end
