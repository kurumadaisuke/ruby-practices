# frozen_string_literal: true

require_relative 'file_info'

class ParamsOption
  attr_accessor :params_options

  def initialize(params_options)
    @params_options = params_options
  end

  def fetch_files_include_a?
    @params_options['a'] || false
  end

  def reverse_files_include_r?
    @params_options['r'] || false
  end

  def format_files_include_l?
    @params_options['l'] || false
  end
end
