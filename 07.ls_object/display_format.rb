# frozen_string_literal: true

require_relative 'file_and_directory_name'

NUMBER_OF_COLUMNS = 3

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

FILETYPE = {
  'fifo' => 'p',
  'characterSpecial' => 'c',
  'directory' => 'd',
  'blockSpecial' => 'b',
  'file' => '-',
  'link' => 'l',
  'socket' => 's'
}.freeze

class DisplayFormat
  # ls -lコマンド時の出力
  def long_filename_output
    sum = @frames.sum { |frame| File.stat(frame).blocks }
    puts "total #{sum}"

    @frames.each do |filename|
      y = File.stat(filename)
      text = [
        filetype_conversion(y.ftype),
        permission_conversion(format('%06d', y.mode.to_s(8)).slice(3, 1)),
        permission_conversion(format('%06d', y.mode.to_s(8)).slice(4, 1)),
        "#{permission_conversion(format('%06d', y.mode.to_s(8)).slice(5, 1))} ",
        "#{y.nlink} ",
        "#{Etc.getpwuid(y.uid).name} ",
        "#{Etc.getgrgid(y.gid).name} ",
        "#{y.size.to_s.rjust(4)} ",
        "#{y.mtime.strftime('%m %d %H:%M')} ",
        filename
      ]
      puts text.join
    end
  end

  # パーミッション定数呼び出し
  def permission_conversion(permission)
    PERMISSION[permission]
  end

  # ファイルタイプ定数呼び出し
  def filetype_conversion(filetype)
    FILETYPE[filetype]
  end

  # lsコマンド(デフォルト)出力
  def default_output
    column_length = @frames.each_slice(NUMBER_OF_COLUMNS).to_a.length
    column_array = @frames.each_slice(column_length).to_a

    if column_array[-1].size < column_length # 各配列の数を合わせるためnilを入れる
      substitution_nil = column_length - column_array[-1].size
      substitution_nil.times { column_array[-1] << nil }
    end

    transposed = column_array.transpose
    transposed.each_with_index do |row, i|
      row.each { |h| print h.to_s.ljust(16) }
      print "\n" if i != transposed.length - 1
    end
  end
end
