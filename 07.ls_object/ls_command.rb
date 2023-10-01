# frozen_string_literal: true
require 'debug'

require_relative 'display_format'

class LsCommand
  def initialize(receive_options)
    @display_format = DisplayFormat.new(receive_options)
  end

  def output
    @display_format.parser_option
  end
end

# binding.break
