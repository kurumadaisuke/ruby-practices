# frozen_string_literal: true

require_relative 'params_option'

COLUMN_SIZE = 4

class LsCommand
  def initialize(params_options)
    @params_options = ParamsOption.new(params_options)
    @file_info_list = file_info_list
  end

  def output
    @params_options.show_long_format? ? long_format(@file_info_list) : default_format(@file_info_list)
  end

  private

  def file_info_list
    flags = @params_options.show_all_files? ? File::FNM_DOTMATCH : 0
    files = Dir.glob('*', flags)
    files.reverse! if @params_options.show_reverse_files?
    files.map { |file_name| FileInfo.new(file_name) }
  end

  def default_format(file_info_list)
    string_length = string_length(file_info_list)
    row_size = file_info_list.each_slice(COLUMN_SIZE).to_a.size
    columns = file_info_list.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each do |row_file_info_list|
      row_file_info_list.each do |file|
        file_name = file&.name.to_s
        print file_name.ljust(string_length)
      end
      puts
    end
  end

  def string_length(file_info_list)
    file_info_list.map { |file| file.name.length }.max + 6
  end

  def long_format(file_info_list)
    total_block_size = total_block_size(file_info_list)
    puts "total #{total_block_size}"

    file_info_list.each do |file|
      puts file.inspect_stats
    end
  end

  def total_block_size(file_info_list)
    file_info_list.sum(&:block_size)
  end
end
