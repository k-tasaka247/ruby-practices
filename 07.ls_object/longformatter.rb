# frozen_string_literal: true

require_relative 'entry'
require_relative 'directory'

class LongFormatter
  def initialize(directory)
    @directory = directory
  end

  def output
    create_long_format_entry_obj
    block_total_row = ["total #{@directory.block_total}"]
    entries_digits = @directory.entries.map(&:digit)
    max_digit = entries_digits.transpose.map(&:max)
    entries_justified = @directory.entries.map do |details|
      details.justify(max_digit)
    end
    block_total_row + entries_justified.map { |entry| entry.join(' ') }
  end

  private

  def create_long_format_entry_obj
    @directory.entries.map(&:details)
  end
end
