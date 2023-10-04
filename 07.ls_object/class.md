# クラス設計書
- LsCommand
  - initialize(receive_options)
  - output

- FileAndDirectory
  attr_accessor :files_and_directories
  - initialize(receive_options)

- DisplayFormatter
  - initialize(receive_options)
  - self.default_format(files_and_directories)
  - self.long_format(files_and_directories
  - self.define_size(files_and_directories)


- DisplayFormat < DisplayFormatter
  attr_accessor :receive_options
  - parser_option
  - include_a?
  - include_r?
  - include_l?

※ constant.rb
COLUMN_SIZE
FILETYPE
PERMISSION
