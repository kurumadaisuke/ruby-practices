#!/usr/bin/env ruby

require 'optparse'
require 'debug'

@output = []
@total = []

def lines_option(filenames)
  @lines = []
  filenames.each {|filename| @lines << File.read(filename).count("\n").to_s.rjust(8)}
  @output << @lines
  if @acquisition_filenames.size >= 2
    @total << filenames.sum { |file| File.read(file).count("\n") }.to_s.rjust(8)
  end
end

def words_option(filenames)
  @words = []
  filenames.each {|file| @words << File.read(file).split(/\s+/).size.to_s.rjust(7) }
  @output << @words
  if @acquisition_filenames.size >= 2
    @total << filenames.sum { |file| File.read(file).split.size }.to_s.rjust(7)
  end
end

def bytes_option(filenames)
  @bytes = []
  filenames.each {|file| @bytes << File.size(file).to_s.rjust(8) }
  @output << @bytes
  if @acquisition_filenames.size >= 2
    @total << filenames.sum { |file| File.size(file) }.to_s.rjust(8)
  end
end

def file_name(filenames)
  @filename = []
  filenames.each {|file| @filename << file }
  @output << @filename
end

def output
  transposed = @output.transpose
  transposed.each { |row| puts row.join(' ') }
  if @acquisition_filenames.size >= 2
    puts "#{@total.join(' ')} total"
  end
end

def pipe_output(output)
  print output.count("\n").to_s.rjust(8)
  print output.split(/\s+/).count.to_s.rjust(8)
  print output.size.to_s.rjust(8)
end

if !ARGV.empty?
  @acquisition_filenames = ARGV
else
  pipe_output = $stdin.readlines.join
  pipe_output(pipe_output)
end

begin
  option = ARGV.getopts('lwc')
  if option['l']  == false && option['w'] == false && option['c'] == false && !ARGV.empty?
    option['l'] = true && option['w'] = true && option['c'] = true
  end
    option['l'] ? lines_option(@acquisition_filenames) : nil
    option['w'] ? words_option(@acquisition_filenames) : nil
    option['c'] ? bytes_option(@acquisition_filenames) : nil
  if !ARGV.empty?
    file_name(@acquisition_filenames)
    output
  end
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end
