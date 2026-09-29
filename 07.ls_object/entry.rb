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

  def initialize(path, entry)
    @entry = entry
    @stat = File.lstat("#{path}/#{@entry}")
  end

  def name
    @entry
  end

  def block_size
    @stat.blocks * 512 / 1024
  end

  def file_type
    FILE_TYPE[@stat.ftype]
  end

  def file_mode
    mode = @stat.mode.to_s(8)
    file_modes = (-3..-1).map { |index| FILE_MODE[mode[index]] }
    special_file_mode = mode[-4].to_i.to_s(2).rjust(3, '0')
    file_modes = file_modes.map.with_index do |mode, i|
      special_file_mode[i] == '1' ? file_mode_make(mode, SPECIAL_FILE_MODE_CHAR[i]) : mode
    end
    file_modes.join
  end

  def nlink
    @stat.nlink
  end

  def user_name
    Etc.getpwuid(@stat.uid).name
  end

  def group_name
    Etc.getgrgid(@stat.gid).name
  end

  def size
    @stat.size
  end

  def mtime
    @stat.mtime
  end
end
