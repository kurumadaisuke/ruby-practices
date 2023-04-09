#!/usr/bin/env ruby
# frozen_string_literal: true

require 'optparse'

@output = []
@total = []

def lines_count(filenames)
  @lines = []
  filenames.each { |filename| @lines << File.read(filename).count("\n").to_s.rjust(8) }
  @output << @lines
  return if @acquisition_filenames.size < 2

  @total << filenames.sum { |file| File.read(file).count("\n") }.to_s.rjust(8)
end

def words_count(filenames)
  @words = []
  filenames.each { |file| @words << File.read(file).split(/\s+/).size.to_s.rjust(7) }
  @output << @words
  return if @acquisition_filenames.size < 2

  @total << filenames.sum { |file| File.read(file).split.size }.to_s.rjust(7)
end

def bytes_count(filenames)
  @bytes = []
  filenames.each { |file| @bytes << File.size(file).to_s.rjust(8) }
  @output << @bytes
  return if @acquisition_filenames.size < 2

  @total << filenames.sum { |file| File.size(file) }.to_s.rjust(8)
end

def file_name(filenames)
  @filename = []
  filenames.each { |file| @filename << file }
  @output << @filename
end

def output
  transposed = @output.transpose
  transposed.each { |row| puts row.join(' ') }
  return if @acquisition_filenames.size < 2

  puts "#{@total.join(' ')} total"
end

def pipe_output(output)
  print output.count("\n").to_s.rjust(8)
  print output.split(/\s+/).count.to_s.rjust(8)
  print output.bytesize.to_s.rjust(8)
end

if !ARGV.empty?
  @acquisition_filenames = ARGV
else
  pipe_output($stdin.read)
end

begin
  option = ARGV.getopts('lwc')
  option['l'] = true && option['w'] = true && option['c'] = true if
  option['l'] == false && option['w'] == false && option['c'] == false && !ARGV.empty?

  lines_count(@acquisition_filenames) if option['l']
  words_count(@acquisition_filenames) if option['w']
  bytes_count(@acquisition_filenames) if option['c']
  unless ARGV.empty?
    file_name(@acquisition_filenames)
    output
  end
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
