# frozen_string_literal: true

class LongFormatter
  RJUST_COLS = %w[1 4 6].freeze

  def initialize(directory)
    @directory = directory
  end

  def format
    entry_rows = build_entry_rows
    entry_digits = entry_rows.map { |row| row.map(&:size) }
    max_digits = entry_digits.transpose.map(&:max)
    justified_lists = entry_rows.map do |row|
      row.map.with_index do |cell, i|
        if RJUST_COLS.include?(i.to_s)
          cell.rjust(max_digits[i], ' ')
        else
          cell.ljust(max_digits[i], ' ')
        end
      end.join(' ')
    end
    block_total_row = ["total #{@directory.block_total}"]
    block_total_row + justified_lists
  end

  private

  def build_entry_rows
    @directory.entries.map do |entry|
      [
        entry.file_type + entry.file_mode,
        entry.nlink.to_s,
        entry.user_name,
        entry.group_name,
        entry.size.to_s,
        entry.mtime.strftime('%b %e'),
        Date.today.to_date - entry.mtime.to_date < 183 ? entry.mtime.strftime('%H:%M') : entry.mtime.year.to_s,
        entry.name
      ]
    end
  end
end
