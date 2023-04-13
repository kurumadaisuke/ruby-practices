#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def format(count)
  count.to_s.rjust(8)
end

def file_read(filenames)
  file_contents = []
  filenames.each { |filename| file_contents << File.read(filename) }
  file_contents
end

def lines_count(file_contents)
  lines = []
  file_contents.each { |content| lines << format(content.count("\n")) }
  lines
end

def words_count(file_contents)
  words = []
  file_contents.each { |content| words << format(content.split.size) }
  words
end

def bytes_count(file_contents)
  bytes = []
  file_contents.each { |content| bytes << format(content.bytesize) }
  bytes
end

def file_name(filenames)
  filenames.map { |filename| " #{filename}" }
end

def output(row, total, filename)
  transposed = row.transpose
  transposed.each { |r| puts r.join }
  puts "#{total.join} total" if filename.size >= 2
end

begin
  option = ARGV.getopts('lwc')
  option['l'] = true && option['w'] = true && option['c'] = true if option['l'] == false && option['w'] == false && option['c'] == false

  if ARGV.any?
    acquisition_filenames = ARGV
    file_contents = file_read(acquisition_filenames)
    filename = file_name(acquisition_filenames)
  else
    file_contents = [$stdin.read]
    filename = []
  end

  row = []
  row << lines_count(file_contents) if option['l']
  row << words_count(file_contents) if option['w']
  row << bytes_count(file_contents) if option['c']

  if ARGV.any?
    row << file_name(acquisition_filenames)
    filename = filename.each(&:strip!)
  end

  total = []
  total << format(filename.sum { |file| File.read(file).count("\n") }) if option['l'] && filename.size >= 2
  total << format(filename.sum { |file| File.read(file).split.size }) if option['w'] && filename.size >= 2
  total << format(filename.sum { |file| File.size(file) }) if option['c'] && filename.size >= 2

  output(row, total, filename)
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
