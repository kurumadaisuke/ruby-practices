# クラス設計書

- LsCommand
  - initialize(params_options)
  - output
  - file_info_list
  - default_format(file_info_list)
  - long_format(file_info_list)
  - character_size_calculator(file_info_list)
  - total_block_size(file_info_list)

- FileInfo
  attr_accessor :name
  - initialize(name)
  - filetype
  - permission
  - hard_link
  - user_name
  - group_name
  - byte_size
  - updated_date
  - block_size
  - show_detail

- ParamsOption
  attr_accessor :params_options
  - initialize(params_options)
  - fetch_files_include_a?
  - reverse_files_include_r?(files)
  - format_files_include_l?
