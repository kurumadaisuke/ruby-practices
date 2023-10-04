# frozen_string_literal: true

require_relative 'file_and_directory'
require_relative 'display_formatter'

class DisplayFormat < DisplayFormatter
  attr_accessor :receive_options

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
    receive_options['l'] ? DisplayFormatter.long_format(@files_and_directories) : DisplayFormatter.default_format(@files_and_directories)
  end
end
