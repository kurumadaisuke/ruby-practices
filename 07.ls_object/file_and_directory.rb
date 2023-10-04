# frozen_string_literal: true

class FileAndDirectory
  attr_accessor :files_and_directories

  def initialize(receive_options)
    @files_and_directories = receive_options['a'] ? Dir.glob('*', File::FNM_DOTMATCH) : Dir.glob('*')
  end
end
