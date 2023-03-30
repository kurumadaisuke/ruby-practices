#!/usr/bin/env ruby

require 'optparse'
require 'debug'

@acquisition_filenames = ARGV

output = $stdin.readlines.join
print output.count("\n").to_s.rjust(8)
print output.split(/\s+/).count.to_s.rjust(8)
print output.size.to_s.rjust(8)

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

begin
  option = ARGV.getopts('lwc')
  if option['l']  == false && option['w'] == false && option['c'] == false
    option['l'] = true && option['w'] = true && option['c'] = true
  end
  option['l'] == true ? lines_option(@acquisition_filenames) : nil
  option['w'] == true ? words_option(@acquisition_filenames) : nil
  option['c'] == true ? bytes_option(@acquisition_filenames) : nil
  file_name(@acquisition_filenames)
  output
rescue OptionParser::InvalidOption => e
  puts "Error Message: #{e.message}"
end

