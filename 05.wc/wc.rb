#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

def format(count)
  count.to_s.rjust(8)
end

def read_files(filenames)
  filenames.map { |filename| File.read(filename) }
end

def lines_count(file_contents)
  file_contents.map { |content| format(content.count("\n")) }
end

def words_count(file_contents)
  file_contents.map { |content| format(content.split.size) }
end

def bytes_count(file_contents)
  file_contents.map { |content| format(content.bytesize) }
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

  total = row[0..-2].map { |a| format(a.map.sum { |r| r.to_i})} if filename.size >= 2

  output(row, total, filename)
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
