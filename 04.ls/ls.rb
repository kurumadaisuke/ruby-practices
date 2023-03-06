#!/usr/bin/env ruby
# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3 # 列数の定義（数字を変える）

def filename_acquisition
  @frames = Dir.glob('*')
  filename_output
end

def filename_output
  column_length = @frames.each_slice(NUMBER_OF_COLUMNS).to_a.length
  column_array = @frames.each_slice(column_length).to_a

  if column_array[-1].size < column_length # 各配列の数を合わせるためnilを入れる
    substitution_nil = column_length - column_array[-1].size
    substitution_nil.times { column_array[-1] << nil }
  end

  transposed = column_array.transpose
  transposed.each_with_index do |row, i|
    row.each { |h| print h.to_s.ljust(16) }
    print "\n" if i != transposed.length - 1
  end
end

filename_acquisition
