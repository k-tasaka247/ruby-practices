# frozen_string_literal: true

require 'etc'
require 'date'

PRINT_COLS_WIDTH = 3
FILE_TYPE = { 'fifo' => 'p', 'characterSpecial' => 'c', 'directory' => 'd', 'blockSpecial' => 'b', 'file' => '-', 'link' => 'l', 'socket' => 's' }.freeze
FILE_MODE = { '0' => '---', '1' => '--x', '2' => '-w-', '3' => '-wx', '4' => 'r--', '5' => 'r-x', '6' => 'rw-', '7' => 'rwx' }.freeze
S_FILE_MODE = { '0' => '--S', '1' => '--s', '2' => '-wS', '3' => '-ws', '4' => 'r-S', '5' => 'r-s', '6' => 'rwS', '7' => 'rws' }.freeze
T_FILE_MODE = { '0' => '--T', '1' => '--t', '2' => '-wT', '3' => '-wt', '4' => 'r-T', '5' => 'r-t', '6' => 'rwT', '7' => 'rwt' }.freeze
LONGFORMAT_COL_WITHOUT_FILE_NAME = 7

def file_mode_judge(file)
  mode = file.mode.to_s(8)
  case mode[-4]
  when '0'
    (-3..-1).map { |index| FILE_MODE[mode[index]] }.join
  when '1'
    [-3, -2].map { |index| FILE_MODE[mode[index]] }.join + T_FILE_MODE[mode[-1]]
  when '2'
    FILE_MODE[mode[-3]] + S_FILE_MODE[mode[-2]] + FILE_MODE[mode[-1]]
  when '3'
    FILE_MODE[mode[-3]] + S_FILE_MODE[mode[-2]] + T_FILE_MODE[mode[-1]]
  when '4'
    S_FILE_MODE[mode[-3]] + [-2, -1].map { |index| FILE_MODE[mode[index]] }.join
  when '5'
    S_FILE_MODE[mode[-3]] + FILE_MODE[mode[-2]] + T_FILE_MODE[mode[-1]]
  when '6'
    [-3, -2].map { |index| S_FILE_MODE[mode[index]] }.join + FILE_MODE[mode[-1]]
  when '7'
    [-3, -2].map { |index| S_FILE_MODE[mode[index]] }.join + T_FILE_MODE[mode[-1]]
  end
end

def number?(str)
  str.match?(/^\s*[0-9]+$/)
end

def ls_elements_get(options, path)
  elements = options[:a] ? Dir.entries(path).sort : Dir.glob('*', base: path).sort
  elements.reverse! if options[:r]
  elements
end

def ls_array_fix(options, path)
  elements = ls_elements_get(options, path)
  row_size = (elements.size / PRINT_COLS_WIDTH.to_f).ceil
  return [[], []] if row_size.zero?

  elements_sliced_by_cols = elements.each_slice(row_size)

  elements_arrays_for_print = Array.new(row_size) { [] }
  each_cols_max_length = Array.new(PRINT_COLS_WIDTH, 0)

  elements_sliced_by_cols.each_with_index do |array, col_number|
    row_size.times do |i|
      element = array[i] || ''
      elements_arrays_for_print[i] << element
      each_cols_max_length[col_number] = [each_cols_max_length[col_number], element.size].max
    end
  end
  [elements_arrays_for_print, each_cols_max_length]
end

def ls_details_get(path, element)
  elements_array = []
  file = File.lstat("#{path}/#{element}")
  elements_array << FILE_TYPE[file.ftype] + file_mode_judge(file)
  elements_array << file.nlink.to_s
  elements_array << Etc.getpwuid(file.uid).name
  elements_array << Etc.getgrgid(file.gid).name
  elements_array << file.size.to_s
  elements_array << "#{Date::ABBR_MONTHNAMES[file.mtime.month]} #{file.mtime.day.to_s.rjust(2)}"
  elements_array << "#{file.mtime.hour.to_s.rjust(2, '0')}:#{file.mtime.min.to_s.rjust(2, '0')}"
  elements_array << element

  block_size = file.blocks * 512 / 1024

  [elements_array, block_size]
end

def ls_longformat_array_fix(options, path)
  elements = ls_elements_get(options, path)
  row_size = elements.size
  return [[], []] if row_size.zero?

  elements_arrays_for_print = Array.new(row_size) { [] }
  total_block_size = 0

  elements.each_with_index do |element, i|
    elements_arrays_for_print[i], block_size = ls_details_get(path, element)
    total_block_size += block_size
  end

  each_cols_max_length = elements_arrays_for_print.transpose.map { |col| col.map(&:size).max }
  elements_arrays_for_print.each do |row|
    LONGFORMAT_COL_WITHOUT_FILE_NAME.times do |col|
      row[col] = number?(row[col]) ? row[col].rjust(each_cols_max_length[col], ' ') : row[col].ljust(each_cols_max_length[col], ' ')
    end
  end

  elements_arrays_for_print.unshift(["total #{total_block_size}"])
  [elements_arrays_for_print, each_cols_max_length]
end

def ls_print(options, path)
  elements_arrays_for_print, each_cols_max_length = options[:l] ? ls_longformat_array_fix(options, path) : ls_array_fix(options, path)

  elements_arrays_for_print.map do |row|
    options[:l] ? row.join(' ') : row.map.with_index { |element, i| element.ljust(each_cols_max_length[i]) }.join('  ')
  end
end
