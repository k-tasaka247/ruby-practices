# frozen_string_literal: true

require 'date'

class LongFormatter
  RJUST_COLS = [1, 4, 6].freeze

  HALF_YEAR_DAYS = 183

  def initialize(directory)
    @directory = directory
  end

  def format
    entry_rows = build_entry_rows
    entry_digits = entry_rows.map { |row| row.map(&:size) }
    max_digits = entry_digits.transpose.map(&:max)
    justified_lists = entry_rows.map do |row|
      justified_row = row.map.with_index do |cell, i|
        if RJUST_COLS.include?(i)
          cell.rjust(max_digits[i], ' ')
        else
          cell.ljust(max_digits[i], ' ')
        end
      end
      justified_row.join(' ')
    end
    ["total #{@directory.block_total}", *justified_lists]
  end

  private

  def build_entry_rows
    @directory.entries.map do |entry|
      time = Date.today - entry.mtime.to_date < HALF_YEAR_DAYS ? entry.mtime.strftime('%H:%M') : entry.mtime.year.to_s
      [
        entry.file_type + entry.file_mode,
        entry.nlink.to_s,
        entry.user_name,
        entry.group_name,
        entry.size.to_s,
        entry.mtime.strftime('%b %e'),
        time,
        entry.name
      ]
    end
  end
end
