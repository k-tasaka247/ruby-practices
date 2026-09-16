# frozen_string_literal: true

STDOUT_MIN_DIGIT = 7

def read_file(path)
  File.read(path)
end

def get_file_size(content)
  content.bytesize
end

def count_lines(content)
  content.lines.count
end

def count_words(content)
  content.split.count
end

def wc_output(path, options)
  file_contents = read_file(path)
  file_data_sizes = get_data_size(file_contents)
  digit = judge_digit(file_data_sizes, options)
  create_output(file_data_sizes, path, options, digit)
end

def fix_array(array, options)
  return array if options.empty?

  array_fixed = []
  array_fixed << array[0] if options[:l]
  array_fixed << array[1] if options[:w]
  array_fixed << array[2] if options[:c]
  array_fixed
end

def wc_stdout_output(lines, options)
  file_data_sizes = get_data_size(lines)
  digit = judge_digit(file_data_sizes, options, STDOUT_MIN_DIGIT)
  create_output(file_data_sizes, nil, options, digit)
end

def get_data_size(content)
  file_data_sizes = []
  file_data_sizes << count_lines(content)
  file_data_sizes << count_words(content)
  file_data_sizes << get_file_size(content)
  file_data_sizes
end

def elements_to_str(array)
  array.map(&:to_s)
end

def count_digit(file_data_sizes, min_digit = 0)
  str_file_data_sizes = elements_to_str(file_data_sizes.flatten)
  [str_file_data_sizes.map(&:size).max, min_digit].max
end

def judge_digit(data_sizes, options, min_digit = 0)
  return nil if options.count == 1

  count_digit(data_sizes, min_digit)
end

def justify(array, digit)
  str_array = elements_to_str(array)
  digit ||= count_digit(str_array)
  str_array.map { |element| element.rjust(digit, ' ') }
end

def create_output(datas, label, options, digit)
  fixed = fix_array(datas, options)
  fixed = justify(fixed, digit) if digit
  [fixed, label].compact.join(' ')
end

def multiple?(array)
  array.size > 1
end

def get_total(path_data_sizes)
  total_data_sizes = path_data_sizes.transpose.map(&:sum)
end

def wc_multiple_output(path_array, options)
  path_data_sizes = path_array.map { |path| get_data_size(read_file(path)) }
  path_data_sizes << get_total(path_data_sizes)
  path_array_fixed = path_array + ['total']
  digit = count_digit(path_data_sizes)

  path_data_sizes.zip(path_array_fixed).map { |datas, path| create_output(datas, path, options, digit) }
end
