# frozen_string_literal: true

require 'etc'
require_relative 'file_and_directory'
require_relative 'constant'
require 'debug'

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
    @files_and_directories = receive_options['r'] ? @files_and_directories.files_and_directories.reverse : @files_and_directories.files_and_directories
  end

  def include_l?
    receive_options['l'] ? long_format(@files_and_directories) : default_format(@files_and_directories)
  end

  def default_format(files_and_directories)
    character_size = files_and_directories.max_by(&:length).size + 6
    row_size = files_and_directories.each_slice(COLUMN_SIZE).to_a.size
    columns = files_and_directories.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each do |row_files_and_directories|
      row_files_and_directories.each do |file_or_directory|
        print file_or_directory.to_s.ljust(character_size)
      end
      print "\n"
    end
  end

  def long_format(files_and_directories)
    define_size(files_and_directories)

    puts "total #{@total_block_size}"
    files_and_directories.each do |file_or_directory|
      file_or_directory_info = File.stat(file_or_directory)

      row_text = [
        FILETYPE[file_or_directory_info.ftype],
        PERMISSION[format('%06d', file_or_directory_info.mode.to_s(8)).slice(3, 1)],
        PERMISSION[format('%06d', file_or_directory_info.mode.to_s(8)).slice(4, 1)],
        "#{PERMISSION[format('%06d', file_or_directory_info.mode.to_s(8)).slice(5, 1)]}  ",
        "#{file_or_directory_info.nlink.to_s.rjust(@max_nlink_length)} ",
        "#{Etc.getpwuid(file_or_directory_info.uid).name.ljust(@max_username_length)} ",
        "#{Etc.getgrgid(file_or_directory_info.gid).name.rjust(@max_groupname_length + 1)} ",
        "#{file_or_directory_info.size.to_s.rjust(@max_bite_length + 1)} ",
        "#{file_or_directory_info.mtime.strftime('%m %d %H:%M')} ",
        file_or_directory
      ]
      puts row_text.join
    end
  end

  def define_size(files_and_directories)
    @total_block_size = files_and_directories.sum { |file_or_directory| File.stat(file_or_directory).blocks }
    @max_nlink_length = files_and_directories.map { |file_or_directory| File.stat(file_or_directory).nlink.to_s.length }.max
    @max_username_length = files_and_directories.map { |file_or_directory| Etc.getpwuid(File.stat(file_or_directory).uid).name.length }.max
    @max_groupname_length = files_and_directories.map { |file_or_directory| Etc.getgrgid(File.stat(file_or_directory).gid).name.length }.max
    @max_bite_length = files_and_directories.map { |file_or_directory| File.stat(file_or_directory).size.to_s.length }.max
  end
end
