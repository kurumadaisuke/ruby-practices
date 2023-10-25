# frozen_string_literal: true

require 'etc'

FILETYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

PERMISSION = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

class FileInfo
  attr_accessor :name

  def initialize(name)
    @name = name
    @file_info = File.stat(name)
  end

  def filetype
    @filetype ||= FILETYPE[@file_info.ftype]
  end

  def permission
    PERMISSION[format('%06d', @file_info.mode.to_s(8)).slice(3, 1)] +
      PERMISSION[format('%06d', @file_info.mode.to_s(8)).slice(4, 1)] +
      PERMISSION[format('%06d', @file_info.mode.to_s(8)).slice(5, 1)]
  end

  def hard_link
    @hard_link ||= @file_info.nlink.to_s
  end

  def user_name
    @user_name ||= Etc.getpwuid(@file_info.uid).name
  end

  def group_name
    @group_name ||= Etc.getgrgid(@file_info.gid).name
  end

  def byte_size
    @byte_size ||= @file_info.size.to_s
  end

  def updated_date
    @updated_date ||= @file_info.mtime.strftime('%m %d %H:%M')
  end

  def block_size
    @block_size ||= @file_info.blocks
  end

  def inspect_stats
    [
      filetype,
      permission,
      "#{hard_link.rjust(3)} ",
      "#{user_name.ljust(14)} ",
      "#{group_name}  ",
      "#{byte_size.rjust(4)} ",
      "#{updated_date} ",
      name
    ].join
  end
end
