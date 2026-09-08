# frozen_string_literal: true

def file_read(path)
  File.read(path)
end

def file_size_get(path)
  File.lstat(path).size.to_s
end

def line_chars_count(content)
  content.size.to_s
end

def line_count(content)
  content.lines.count.to_s
end

def words_count(content)
  content.split.count.to_s
end

def wc_output(path, options)
  file_datas = file_data_get(path)
  file_datas = wc_justify(file_datas) unless options.count == 1
  file_datas_fixed = array_fix(file_datas, options)
  [file_datas_fixed, path].join(' ')
end

def array_fix(array, options)
  return array if options.empty?

  array_fixed = []
  array_fixed << array[0] if options[:l]
  array_fixed << array[1] if options[:w]
  array_fixed << array[2] if options[:c]
  array_fixed
end

def wc_stdout_output(lines, options)
  file_datas = []
  file_datas << line_count(lines)
  file_datas << words_count(lines)
  file_datas << line_chars_count(lines)
  digit = [file_datas.map(&:size).max, 7].max unless options.count == 1
  file_datas_fixed = array_fix(file_datas, options)
  file_datas_justified = wc_justify(file_datas_fixed, digit)
  file_datas_justified.join(' ')
end

def file_data_get(path)
  file_datas = []
  file_content = file_read(path)
  file_datas << line_count(file_content)
  file_datas << words_count(file_content)
  file_datas << file_size_get(path)
  file_datas
end

def wc_justify(array, digit = nil)
  digit ||= array.map(&:size).max
  array.map { |element| element.rjust(digit, ' ') }
end

def multiple?(array)
  array.size > 1
end

def total_get(path_datas)
  total_datas = [0, 0, 0]
  path_datas.each do |data|
    data.each_with_index { |element, i| total_datas[i] += element.to_i }
  end
  total_datas.map(&:to_s)
end

def wc_multiple_output(path_array, options)
  path_datas = path_array.map { |path| file_data_get(path) }
  path_datas << total_get(path_datas)
  path_datas_justified = wc_justify(path_datas.flatten).each_slice(3).to_a
  path_datas_fixed = path_datas_justified.map { |datas| array_fix(datas, options) }
  path_array << 'total'
  path_datas_fixed.map.with_index { |data, i| [data, path_array[i]].join(' ') }
end
