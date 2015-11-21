#!/usr/bin/ruby
## util
require "logger" 


class Util

	@log
	@config_file

	def initialize(name)
		@log = Logger.new("../../etc/log")
		@log.info "--util.rb : util.initialize calld by " + name
		@config_file="../../config.txt"
	end

	def info(comment)
		@log.info comment
	end

	## getconf
	## ARGV[1] = parameter
	def getconf(target)
		@log.info "--util.rb : util.getconf( " + target + ") "
		File.foreach(@config_file) do |line|
		#File.foreach("../../config.txt") do |line|
			conf = line.chomp
			if(conf.index(target)) then
				@log.info "return " + conf.split[1]
				return conf.split[1]
			end
		end
	end


end

#### main
#util = Util.new("Util main for test")
#result = util.getconf("TIMESTAMP")
#result = result.to_i * 2
#print result,"\n"

