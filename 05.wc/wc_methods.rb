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
  file_body_sizes = count_size(file_contents)
  digit = count_digit(file_body_sizes, options)
  create_output(file_body_sizes, path, options, digit)
end

def pick_by_option(sizes, options)
  return sizes if options.empty?

  fixed = []
  fixed << sizes[0] if options[:l]
  fixed << sizes[1] if options[:w]
  fixed << sizes[2] if options[:c]
  fixed
end

def wc_stdout_output(lines, options)
  file_body_sizes = count_size(lines)
  digit = count_digit(file_body_sizes, options, STDOUT_MIN_DIGIT)
  create_output(file_body_sizes, nil, options, digit)
end

def count_size(content)
  [
    count_lines(content),
    count_words(content),
    get_file_size(content)
  ]
end

def elements_to_str(array)
  array.map(&:to_s)
end

def count_digit(body_sizes, options, min_digit = 0)
  return nil if options.count == 1

  str_file_body_sizes = elements_to_str(body_sizes.flatten)
  [str_file_body_sizes.map(&:size).max, min_digit].max
end

def justify(sizes, digit)
  str_sizes = elements_to_str(sizes)
  str_sizes.map { |size| size.rjust(digit, ' ') }
end

def create_output(sizes, label, options, digit)
  fixed = pick_by_option(sizes, options)
  fixed = justify(fixed, digit) if digit
  [fixed, label].compact.join(' ')
end

def multiple?(array)
  array.size > 1
end

def get_total(path_body_sizes)
  path_body_sizes.transpose.map(&:sum)
end

def wc_multiple_output(paths, options)
  path_body_sizes = paths.map { |path| count_size(read_file(path)) }
  path_body_sizes << get_total(path_body_sizes)
  paths_fixed = paths + ['total']
  digit = count_digit(path_body_sizes, {})

  path_body_sizes.zip(paths_fixed).map { |sizes, path| create_output(sizes, path, options, digit) }
end
