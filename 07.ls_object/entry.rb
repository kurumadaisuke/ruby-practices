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

class Entry
  attr_accessor :name, :filetype, :permission, :hard_link, :user_name, :group_name, :byte_size, :updated_date, :block_size

  def initialize(name)
    @entry_info = File.stat(name)
    @name = name
    @filetype = FILETYPE[@entry_info.ftype]
    @permission = build_permission
    @hard_link = @entry_info.nlink.to_s
    @user_name = Etc.getpwuid(@entry_info.uid).name
    @group_name = Etc.getgrgid(@entry_info.gid).name
    @byte_size = @entry_info.size.to_s
    @updated_date = @entry_info.mtime.strftime('%m %d %H:%M')
    @block_size = @entry_info.blocks
  end

  def build_permission
    PERMISSION[format('%06d', @entry_info.mode.to_s(8)).slice(3, 1)] +
      PERMISSION[format('%06d', @entry_info.mode.to_s(8)).slice(4, 1)] +
      PERMISSION[format('%06d', @entry_info.mode.to_s(8)).slice(5, 1)]
  end
end
