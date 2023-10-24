# frozen_string_literal: true

require_relative 'params_option'

COLUMN_SIZE = 4

class LsCommand
  def initialize(params_options)
    @params_options = ParamsOption.new(params_options)
    @file_info_list = file_info_list
  end

  def output
    @params_options.format_files_include_l? ? long_format(@file_info_list) : default_format(@file_info_list)
  end

  def file_info_list
    files = Dir.glob('*', @params_options.fetch_files_include_a?)
    files = @params_options.reverse_files_include_r?(files)
    files.map { |file_name| FileInfo.new(file_name) }
  end

  def default_format(file_info_list)
    character_size = character_size_calculator(file_info_list)
    row_size = file_info_list.each_slice(COLUMN_SIZE).to_a.size
    columns = file_info_list.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each do |row_file_info_list|
      row_file_info_list.each do |file|
        file_name = file ? file.name.to_s : file.to_s
        print file_name.ljust(character_size)
      end
      print "\n"
    end
  end

  def character_size_calculator(file_info_list)
    max_length = 0
    file_info_list.each do |file|
      name_length = file.name.length
      max_length = name_length if name_length > max_length
    end
    max_length + 6
  end

  def long_format(file_info_list)
    total_block_size = total_block_size(file_info_list)
    puts "total #{total_block_size}"

    file_info_list.each do |file|
      row_text = file.show_detail
      puts row_text.join
    end
  end

  def total_block_size(file_info_list)
    total_block_size = 0
    file_info_list.each do |file|
      total_block_size += file.block_size
    end
    total_block_size
  end
end
