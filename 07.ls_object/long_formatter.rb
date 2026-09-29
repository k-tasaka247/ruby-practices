# frozen_string_literal: true

class LongFormatter
  def initialize(directory)
    @directory = directory
  end

  def output
    l_format_rows = build_long_format_entry
    block_total_row = ["total #{@directory.block_total}"]
    entries_digits = l_format_rows.map { |row| row.map(&:size) }
    max_digit = entries_digits.transpose.map(&:max)
    entries_justified = l_format_rows.map do |row|
      row.map.with_index do |detail, i|
        number_string?(detail) ? detail.rjust(max_digit[i], ' ') : detail.ljust(max_digit[i], ' ')
      end
    end
    block_total_row + entries_justified.map { |entry| entry.join(' ') }
  end

  private

  def build_long_format_entry
    @directory.entries.map do |entry|
      l_format_row = []
      l_format_row << entry.file_type + entry.file_mode
      l_format_row << entry.nlink.to_s
      l_format_row << entry.user_name
      l_format_row << entry.group_name
      l_format_row << entry.size.to_s
      l_format_row << entry.date
      l_format_row << entry.time
      l_format_row << entry.name
    end
  end

  def number_string?(str)
    str.match?(/^\s*[0-9]+$/)
  end
end
