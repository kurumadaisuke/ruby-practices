#!/usr/bin/env ruby
# frozen_string_literal: true

def filename_acquisition
  @frames = Dir.glob("*")
  filename_output
end

def filename_output
  column_length = @frames.each_slice(3).to_a.length # 4列の場合[3]のところを4にする
  column_array = @frames.each_slice(column_length).to_a

  if column_array[-1].size < column_length # 各配列の数を合わせるためnilを入れる
    loop do
      column_array[-1] << nil
      break if column_array[-1].size >= column_length
    end
  end

  column_array.transpose.each_with_index do |row, i| # ファイル名を出力する
    row.map { |h| print h.to_s.ljust(16) }
    print "\n" if i != column_array.transpose.length - 1 # 最後だけ改行をしない
  end
end

filename_acquisition
