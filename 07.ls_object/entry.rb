# frozen_string_literal: true

require 'date'
require 'etc'

class Entry
  FILE_TYPE = {
    'fifo' => 'p',
    'characterSpecial' => 'c',
    'directory' => 'd',
    'blockSpecial' => 'b',
    'file' => '-',
    'link' => 'l',
    'socket' => 's'
  }.freeze
  FILE_MODE = {
    '0' => '---', '1' => '--x', '2' => '-w-',
    '3' => '-wx', '4' => 'r--', '5' => 'r-x',
    '6' => 'rw-', '7' => 'rwx'
  }.freeze
  SPECIAL_FILE_MODE_CHAR = %w[s s t].freeze

  attr_reader :entry

  def initialize(path, entry)
    @path = path
    @entry = entry
    @file = File.lstat("#{@path}/#{@entry}")
  end

  def length
    @entry.length
  end

  def digit
    @details.map(&:size)
  end

  def justify(digit)
    return @entry.ljust(digit) if digit.instance_of?(Integer)

    @details.map.with_index do |detail, i|
      number_string?(detail) ? detail.rjust(digit[i], ' ') : detail.ljust(digit[i], ' ')
    end
  end

  def block_size
    @file.blocks * 512 / 1024
  end

  def details
    @details = []
    @details << FILE_TYPE[@file.ftype] + judge_file_mode
    @details << @file.nlink.to_s
    @details << Etc.getpwuid(@file.uid).name
    @details << Etc.getgrgid(@file.gid).name
    @details << @file.size.to_s
    @details << @file.mtime.strftime('%b %d')
    @details << (Date.today.to_date - @file.mtime.to_date < 183 ? @file.mtime.strftime('%H:%M') : @file.mtime.year.to_s)
    @details << @entry
  end

  private

  def number_string?(str)
    str.match?(/^\s*[0-9]+$/)
  end

  def judge_file_mode
    mode = @file.mode.to_s(8)
    file_modes = (-3..-1).map { |index| FILE_MODE[mode[index]] }
    special_file_mode = mode[-4].to_i.to_s(2).rjust(3, '0')
    file_modes = file_modes.map.with_index do |mode, i|
      special_file_mode[i] == '1' ? file_mode_make(mode, SPECIAL_FILE_MODE_CHAR[i]) : mode
    end
    file_modes.join
  end
end
