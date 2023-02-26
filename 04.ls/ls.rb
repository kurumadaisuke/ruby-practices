#!/usr/bin/env ruby
require 'debug'

filenames = Dir.glob("*") # ファイル名一覧の取得
frames = []

filenames.each do |filename| # idとファイル名をハッシュで管理
  frames << filename
end

column_length = frames.each_slice(3).to_a.length # 4列の場合[3]のところを4にする
column_array = frames.each_slice(column_length).to_a

if column_array[-1].size < column_length
  loop{
    column_array[-1] << nil
    break if column_array[-1].size >= column_length
  }
end

column_array.transpose.each_with_index do |row, i| # ファイル名を順番に合わせて出力する
  row.map{|h| print h.to_s.ljust(16)}
  print "\n" if !(i == column_array.transpose.length - 1)
end

# binding.break
