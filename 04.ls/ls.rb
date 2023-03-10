#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

NUMBER_OF_COLUMNS = 3 # 列数の定義（数字を変える）

def all_filename_acquisition
  @frames = Dir.glob('*', File::FNM_DOTMATCH)
  filename_output
end

def default_filename_acquisition
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

OptionParser.new do |opt|
  opt.on('-a', 'Show all file names.') { |o| @all = o }
  begin
    opt.parse! # オプション解析してくれる
  rescue OptionParser::InvalidOption => e # 存在しないオプションを指定された場合
    puts "Error Message: #{e.message}"
    puts opt
    exit
  end
end

if @all == true
  all_filename_acquisition
else
  default_filename_acquisition
end
