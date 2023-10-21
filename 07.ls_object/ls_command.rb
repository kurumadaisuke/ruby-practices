# frozen_string_literal: true

require_relative 'params_option'
require 'debug'
# binding.break

COLUMN_SIZE = 4

class LsCommand
  def initialize(params_options)
    @params_options = ParamsOption.new(params_options)
    @entries_list = @params_options.entries_list
  end

  def output
    @entries_list = @params_options.reverse_entries?(@entries_list)
    default_format(@entries_list)
  end

  def default_format(entries_list)
    character_size = character_size_calculator(entries_list)
    row_size = entries_list.each_slice(COLUMN_SIZE).to_a.size
    columns = entries_list.each_slice(row_size).to_a
    columns[-1].fill(nil, columns[-1].size...row_size)

    columns.transpose.each do |row_entries_list|
      row_entries_list.each do |entry|
        if entry
          print entry.name.to_s.ljust(character_size)
        else
          print entry.to_s.ljust(character_size)
        end
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
end
