#!/usr/bin/env ruby
require 'debug'

filenames = Dir.glob("*") # ファイル名一覧の取得
frames = []

filenames.each do |filename| # idとファイル名をハッシュで管理
  frames << {filename: filename}
end

column_length = frames.each_slice(3).to_a.length # 4列の場合[3]のところを4にする
column_array = frames.each_slice(column_length).to_a

if column_array[-1].size < column_length
    loop{
    column_array[-1] << {filename: ""}
    if column_array[-1].size >= column_length
      break
    end
  }
end

column_array.transpose.each do |row| # ファイル名を順番に合わせて出力する
  binding.break
  row.each do |hash|
    print hash[:filename].to_s.ljust(20)
  end
  print "\n"
end

# binding.break
