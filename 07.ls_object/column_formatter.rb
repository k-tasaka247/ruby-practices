# frozen_string_literal: true

class ColumnFormatter
  MAX_COLS = 3

  def initialize(directory)
    @directory = directory
  end

  def format
    rows = build_cols(@directory.entries).transpose
    rows.map { |row| row.compact.join('  ') }
  end

  private

  def build_cols(entries)
    row_size = entries.size.ceildiv(MAX_COLS)
    col_group = MAX_COLS.times.map do |i|
      index = row_size * i
      entries.values_at((index)...(index + row_size))
    end
    lengths = col_group.map do |entries|
      entries.compact.map { |entry| entry.name.length }.max
    end
    col_group.map.with_index do |col, i|
      col.map { |entry| entry ? entry.name.ljust(lengths[i]) : entry }
    end
  end
end
