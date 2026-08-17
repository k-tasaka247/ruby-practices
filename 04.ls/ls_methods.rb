# frozen_string_literal: true

PRINT_COLS_WIDTH = 3

def ls_array_fix(path)
  elements = Dir.glob('*', base: path || '.').sort

  row_size = (elements.size / PRINT_COLS_WIDTH.to_f).ceil
  elements_sliced_by_cols = row_size.positive? ? elements.each_slice(row_size) : elements

  elements_arrays_for_print = []
  each_cols_max_length = []
  row_size.times { elements_arrays_for_print << [] }
  PRINT_COLS_WIDTH.times { each_cols_max_length << 0 }

  elements_sliced_by_cols.each_with_index do |array, i|
    row_size.times.with_index do |j, k|
      elements_arrays_for_print[k] << (array[j].nil? ? '' : array[j])
      element_length = elements_arrays_for_print[k][i].size
      each_cols_max_length[i] = element_length > each_cols_max_length[i] ? element_length : each_cols_max_length[i]
    end
  end
  [elements_arrays_for_print, each_cols_max_length]
end

def ls_print(path = '.')
  elements_arrays_for_print, each_cols_max_length = ls_array_fix(path)

  elements_arrays_for_print.map do |row|
    row.map.with_index { |element, i| element.ljust(each_cols_max_length[i]) }.join('  ')
  end
end
