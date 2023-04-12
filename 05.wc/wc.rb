#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'
require 'debug'

def format(count)
  count.to_s.rjust(8)
end

def file_read(filenames)
  file_content = []
  filenames.each { |filename| file_content << File.read(filename) }
  return file_content
end

def lines_count(filenames)
  lines = []
  filenames.each { |filename| lines << format(File.read(filename).count("\n")) }
  return lines
end

def words_count(filenames)
  words = []
  filenames.each { |file| words << format(File.read(file).split(/\s+/).size) }
  return words
end

def bytes_count(filenames)
  bytes = []
  filenames.each { |file| bytes << format(File.size(file)) }
  return bytes
end

def file_name(filenames)
  file_name = []
  filenames.each { |f| file_name << " #{f}" }
  return file_name
end

def output(row, total, filename)
  transposed = row.transpose
  transposed.each { |row| puts row.join }
  puts "#{total.join(' ')} total" if filename.size >= 2
end

def pipe_output(output)
  print output.count("\n").to_s.rjust(8)
  print output.split(/\s+/).count.to_s.rjust(8)
  print output.bytesize.to_s.rjust(8)
end

begin
  if !ARGV.empty?
  acquisition_filenames = ARGV
  else
  acquisition_filenames = [$stdin.read]
# pipe_output($stdin.read)
  end

  option = ARGV.getopts('lwc')
  option['l'] = true && option['w'] = true && option['c'] = true if option['l'] == false && option['w'] == false && option['c'] == false && !ARGV.empty?

  filename = file_name(acquisition_filenames)
  file_content = file_read(acquisition_filenames)

  row = []
  row << lines_count(acquisition_filenames) if option['l']
  row << words_count(acquisition_filenames) if option['w']
  row << bytes_count(acquisition_filenames) if option['c']
  row << file_name(acquisition_filenames)

  # binding.break
  total = []
  filename = filename.each { |f| f.strip! }
  total << filename.sum { |file| File.read(file).count("\n") }.to_s.rjust(8) if option['l'] && filename.size >= 2
  total << filename.sum { |file| File.read(file).split.size }.to_s.rjust(7) if option['w'] && filename.size >= 2
  total << filename.sum { |file| File.size(file) }.to_s.rjust(7) if option['c'] && filename.size >= 2

  unless ARGV.empty?
    output(row, total, filename)
  end
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
