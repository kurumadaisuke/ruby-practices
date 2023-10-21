# frozen_string_literal: true

require_relative 'entry'

class ParamsOption
  attr_accessor :params_options

  def initialize(params_options)
    @params_options = params_options
  end

  def entries_list
    @entries = fetch_entries_include_a?
    @entries.map { |entry_name| Entry.new(entry_name) }
  end

  def fetch_entries_include_a?
    flags = @params_options['a'] ? File::FNM_DOTMATCH : 0
    Dir.glob('*', flags)
  end

  def reverse_entries_include_r?(entries)
    @params_options['r'] ? entries.reverse : entries
  end

  def format_entries_include_l?
    @params_options['l'] ? true : false
  end
end
