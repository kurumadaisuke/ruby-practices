#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'tempfile'
require 'etc'
require 'time'

NUMBER_OF_COLUMNS = 3 # 列数の定義（数字を変える）

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

  total_block_size = []
  frames.each do |filename|
    y = File.stat(filename)
    total_block_size <<  y.blocks
  end
  puts "total #{total_block_size.sum}"

  frames.each do |filename|
    y = File.stat(filename)
    space = "  "
    filetype = filetype_conversion(y.ftype)
    permission = "%06d"% y.mode.to_s(8)
    owner_permission = permission_conversion(permission.slice(3, 1))
    owner_group_permission = permission_conversion(permission.slice(4, 1))
    other_permission = permission_conversion(permission.slice(5, 1))
    hard_link = y.nlink.to_s + space
    user_name = Etc.getpwuid(y.uid).name + space
    group_name = Etc.getgrgid(y.gid).name + space
    file_size = y.size.to_s.rjust(4) + space
    data_of_last_change = y.mtime.strftime("%m %d %H:%M") + space

    print filetype + owner_permission + owner_group_permission + other_permission + space
    puts hard_link + user_name + group_name + file_size + data_of_last_change + filename
  end
end

def permission_conversion(permission)
  case permission
    when "0"
      "---"
    when "1"
      "--x"
    when "2"
      "-w-"
    when "3"
      "-wx"
    when "4"
      "r--"
    when "5"
      "r-x"
    when "6"
      "rw-"
    when "7"
      "rwx"
  end
end

def filetype_conversion(filetype)
  case filetype
    when "fifo"
      "p"
    when "characterSpecial"
      "c"
    when "directory"
      "d"
    when "blockSpecial"
      "b"
    when "file"
      "-"
    when "link"
      "l"
    when "socket"
      "s"
  end
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
