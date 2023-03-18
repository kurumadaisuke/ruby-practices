#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'etc'

NUMBER_OF_COLUMNS = 3 # 列数の定義（数字を変える）
PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze
FILETYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

def default_filename_acquisition
  @frames = Dir.glob('*')
  filename_output
end

def all_filename_acquisition
  @frames = Dir.glob('*', File::FNM_DOTMATCH)
  filename_output
end

def reverse_filename_acquisition
  @frames = Dir.glob('*').reverse
  filename_output
end

def long_filename_acquisition
  frames = Dir.glob('*')
  sum = frames.sum {|frame| File.stat(frame).blocks }
  puts "total #{sum}"

  frames.each do |filename|
    y = File.stat(filename)
    space = '  '
    filetype = filetype_conversion(y.ftype)
    permission = format('%06d', y.mode.to_s(8))
    owner_permission = permission_conversion(permission.slice(3, 1))
    owner_group_permission = permission_conversion(permission.slice(4, 1))
    other_permission = permission_conversion(permission.slice(5, 1))
    hard_link = y.nlink.to_s + space
    user_name = Etc.getpwuid(y.uid).name + space
    group_name = Etc.getgrgid(y.gid).name + space
    file_size = y.size.to_s.rjust(4) + space
    data_of_last_change = y.mtime.strftime('%m %d %H:%M') + space

    text = [filetype, owner_permission, owner_group_permission, other_permission, space, hard_link, user_name, group_name, file_size, data_of_last_change, filename]
    puts text.join
  end
end

def permission_conversion(permission)
  PERMISSION[permission]
end

def filetype_conversion(filetype)
  FILETYPE[filetype]
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
  opt.on('-r', 'Reverse file order.') { |o| @reverse = o }
  opt.on('-l', 'Long format file.') { |o| @long = o }
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
elsif @reverse == true
  reverse_filename_acquisition
elsif @long == true
  long_filename_acquisition
else
  default_filename_acquisition
end
