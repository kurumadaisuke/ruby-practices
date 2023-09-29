# frozen_string_literal: true

require 'optparse'
require_relative 'ls'

receive_options = ARGV.getopts('arl')
ls = Ls.new(receive_options)
