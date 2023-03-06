#!/usr/bin/env ruby
# frozen_string_literal: true

NUMBER_OF_COLUMNS = 3 # 列数の定義

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
  
  column_array.transpose.each_with_index do |row, i| # ファイル名を出力する
    row.each { |h| print h.to_s.ljust(16) }
    print "\n" if i != column_array.transpose.length - 1 # 最後だけ改行をしない
  end
end

filename_acquisition
