#!/usr/bin/env ruby

require 'optparse'
require 'debug'

acquisition_filenames = ARGV

def lines_option(filenames)
  @lines = []
  filenames.each {|filename| @lines << File.read(filename).count("\n").to_s.rjust(8)}
end

def words_option(filenames)
  @words = []
  filenames.each {|file| @words << File.read(file).split(/\s+/).size.to_s.rjust(7) }
end

def bytes_option(filenames)
  @bytes = []
  filenames.each {|file| @bytes << File.size(file).to_s.rjust(8) }
end

def file_name(filenames)
  @filename = []
  filenames.each {|file| @filename << file }
end

# if filenames.size >= 2
#   total_lines = filenames.sum { |file| File.read(file).count("\n") }
#   total_bytes = filenames.sum { |file| File.read(file).split.size }
#   total_words = filenames.sum { |file| File.size(file) }
#   total_text = [
#     "#{total_lines.to_s.rjust(8)} ",
#     "#{total_bytes.to_s.rjust(7)} ",
#     "#{total_words.to_s.rjust(8)} ",
#     "total"
#   ]
#   puts total_text.join
# end


begin
  option = ARGV.getopts('lwc')
  if option['l']  == false && option['w'] == false && option['c'] == false
    option['l'] = true
    option['w'] = true
    option['c'] = true
  end
  option['l'] == true ? lines_option(acquisition_filenames) : nil
  option['w'] == true ? words_option(acquisition_filenames) : nil
  option['c'] == true ? bytes_option(acquisition_filenames) : nil
  file_name(acquisition_filenames)
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end

p @lines
p @words
p @bytes
p @filename


# filename.each do |file|
#   text = [
#     "#{File.read(file).count("\n").to_s.rjust(8)} ",
#     "#{File.read(file).split(/\s+/).size.to_s.rjust(7)} ",
#     "#{File.size(file).to_s.rjust(8)} ",
#     file
#   ]
#   puts text.join
# end