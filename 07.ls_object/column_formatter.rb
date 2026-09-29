# frozen_string_literal: true

class ColumnFormatter
  MAX_COLS = 3

  def initialize(directory)
    @directory = directory
  end

  def output
    rows = build_cols(@directory.entries).transpose
    rows.map { |row| row.compact.join('  ') }
  end

  private

  def build_cols(entries)
    col_group = []
    row_size = entries.size.ceildiv(MAX_COLS)
    MAX_COLS.times do |i|
      index = row_size * i
      col_group << entries.values_at((index)...(index + row_size))
    end
    lengths = col_group.map do |entries_col|
                entries_col.compact.map{ |entry| entry.name.length }.max
              end
    col_group.map.with_index do |col, i|
      col.map { |entry| entry ? entry.name.ljust(lengths[i]) : entry }
    end
  end
end
