#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def format(count)
  count.to_s.rjust(8)
end

def read_files(filenames)
  file_contents = []
  filenames.map { |filename| file_contents << File.read(filename) }
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

def output(row, total, filename)
  transposed = row.transpose
  transposed.each { |r| puts r.join }
  puts "#{total.join} total" if filename.size >= 2
end

begin
  option = ARGV.getopts('lwc')
  option = { 'l' => true, 'w' => true, 'c' => true } if !option['l'] && !option['w'] && !option['c']

  if ARGV.any?
    filenames = ARGV
    file_contents = read_files(filenames)
    filename = filenames.map { |f| " #{f}" }
  else
    file_contents = [$stdin.read]
    filename = []
  end

  row = []
  row << lines_count(file_contents) if option['l']
  row << words_count(file_contents) if option['w']
  row << bytes_count(file_contents) if option['c']

  if ARGV.any?
    row << filenames.map { |f| " #{f}" }
    filename = filename.each(&:strip!)
  end

  if filename.size >= 2
    total = []
    total << format(filename.sum { |file| File.read(file).count("\n") }) if option['l']
    total << format(filename.sum { |file| File.read(file).split.size }) if option['w']
    total << format(filename.sum { |file| File.size(file) }) if option['c']
  end

  output(row, total, filename)
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
