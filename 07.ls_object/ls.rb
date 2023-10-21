# frozen_string_literal: true
require 'optparse'
require_relative 'ls_command'
require 'debug'

@ls_command = LsCommand.new(ARGV.getopts('arl'))
@ls_command.output
