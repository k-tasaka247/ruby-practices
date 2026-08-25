# frozen_string_literal: true

PRINT_COLS_WIDTH = 3

def ls_contents_get(options, path = '.')
  if options[:a]
    Dir.entries(path).sort
  else
    Dir.glob('*', base: path || '.').sort
  end
end

def ls_array_fix(options, path = '.')
  elements = ls_contents_get(options, path)
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

def ls_print(options, path = '.')
  elements_arrays_for_print, each_cols_max_length = ls_array_fix(options, path)

  elements_arrays_for_print.map do |row|
    row.map.with_index { |element, i| element.ljust(each_cols_max_length[i]) }.join('  ')
  end
end
