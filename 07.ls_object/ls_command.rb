# frozen_string_literal: true

require_relative 'params_option'

COLUMN_SIZE = 4

class LsCommand
  def initialize(params_options)
    @params_options = ParamsOption.new(params_options)
  end

  def output
    @entries_list = entries_list
    @params_options.format_entries_include_l? ? long_format(@entries_list) : default_format(@entries_list)
  end

  def entries_list
    entries = Dir.glob('*', @params_options.fetch_entries_include_a?)
    entries = @params_options.reverse_entries_include_r?(entries)
    entries.map { |entry_name| FileInfo.new(entry_name) }
  end

  def default_format(entries_list)
    character_size = character_size_calculator(entries_list)
    row_size = entries_list.each_slice(COLUMN_SIZE).to_a.size
    columns = entries_list.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each do |row_entries_list|
      row_entries_list.each do |entry|
        entry_name = entry ? entry.name.to_s : entry.to_s
        print entry_name.ljust(character_size)
      end
      print "\n"
    end
  end

  def character_size_calculator(entries_list)
    max_length = 0
    entries_list.each do |entry|
      name_length = entry.name.length
      max_length = name_length if name_length > max_length
    end
    max_length + 6
  end

  def long_format(entries_list)
    total_block_size = total_block_size(entries_list)
    puts "total #{total_block_size}"

    entries_list.each do |entry|
      row_text = entry.show_detail
      puts row_text.join
    end
  end

  def total_block_size(entries_list)
    total_block_size = 0
    entries_list.each do |entry|
      total_block_size += entry.block_size
    end
    total_block_size
  end
end
