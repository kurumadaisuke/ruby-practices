# frozen_string_literal: true

require_relative 'file_info'

class ParamsOption
  attr_accessor :params_options

  def initialize(params_options)
    @params_options = params_options
  end

  def fetch_entries_include_a?
    @params_options['a'] ? File::FNM_DOTMATCH : 0
  end

  def reverse_entries_include_r?(entries)
    @params_options['r'] ? entries.reverse : entries
  end

  def format_entries_include_l?
    @params_options['l'] ? true : false
  end
end
