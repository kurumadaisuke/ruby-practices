# frozen_string_literal: true

require_relative 'file_info'

class ParamsOption
  attr_accessor :params_options

  def initialize(params_options)
    @params_options = params_options
  end

  def show_all_files?
    @params_options['a'] || false
  end

  def show_reverse_files?
    @params_options['r'] || false
  end

  def format_type?
    @params_options['l'] || false
  end
end
