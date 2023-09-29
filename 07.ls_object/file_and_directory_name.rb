# frozen_string_literal: true

class FileAndDirectoryName
  attr_accessor :file_and_directory_name

  def initialize(receive_a_option: false)
    @file_and_directory_name = get_path_file_and_directory_name(receive_a_option)
  end

  def get_path_file_and_directory_name(receive_a_option)
    receive_a_option == true ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
