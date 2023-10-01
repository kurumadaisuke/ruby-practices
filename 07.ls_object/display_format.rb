# frozen_string_literal: true
require 'debug'
require 'etc'
require_relative 'file_and_directory'
require_relative 'constant'

class DisplayFormat
  attr_accessor :receive_options

  def initialize(receive_options)
    @receive_options = receive_options
  end

  def parser_option
    include_a?
    include_r?
    include_l?
  end

  def include_a?
    @files_and_directories = FileAndDirectory.new(receive_options)
  end

  def include_r?
    @files_and_directories = if receive_options['r'] == true
      @files_and_directories.files_and_directories.reverse
    else
      @files_and_directories.files_and_directories
    end
  end

  def include_l?
    receive_options['l'] == true ? long_format(@files_and_directories) : default_format(@files_and_directories)
  end

  def default_format(files_and_directories)
    max_character_size = files_and_directories.max_by(&:length).size + 6
    row_size = files_and_directories.each_slice(COLUMN_SIZE).to_a.size
    columns = files_and_directories.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each_with_index do |row_files_and_directories, i|
      row_files_and_directories.each do |file_or_directory|
        print file_or_directory.to_s.ljust(max_character_size)
      end
      print "\n"
    end
  end

  def long_format(files_and_directories)
    total_block_size = files_and_directories.sum { |file_or_directory| File.stat(file_or_directory).blocks }
    puts "total #{total_block_size}"

    files_and_directories.each do |file_or_directory|
      y = File.stat(file_or_directory)
      text = [
        CONVERSION_FILETYPE[y.ftype],
        CONVERSION_FILETYPE(format('%06d', y.mode.to_s(8)).slice(3, 1)),
        CONVERSION_FILETYPE(format('%06d', y.mode.to_s(8)).slice(4, 1)),
        "#{CONVERSION_FILETYPE(format('%06d', y.mode.to_s(8)).slice(5, 1))} ",
        "#{y.nlink} ",
        "#{Etc.getpwuid(y.uid).name} ",
        "#{Etc.getgrgid(y.gid).name} ",
        "#{y.size.to_s.rjust(4)} ",
        "#{y.mtime.strftime('%m %d %H:%M')} ",
        file_or_directory
      ]
      puts text.join
    end
  end
end
