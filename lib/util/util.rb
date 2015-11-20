#!/usr/bin/ruby
## util
require "logger" 
require '../util/util.rb'


class Util
	
	@log
	def initialize
		@log = Logger.new("../../etc/log")
		@log.info('--util.rb : util->initialize')

		@config_file="../../config.txt"
	end
	def read_csv( filename )
		print filename
	end

	## getconf
	## ARGV[1] = parameter
	def getconf(target)
		File.foreach(@config_file) do |line|
			conf = line.chomp
			if(conf.index(target)) then
				return conf.split[1]
			end
		end
	end

end

#### main
util = Util.new()
#util.read_csv(ARGV[0])
result = util.getconf("TIMESTAMP")
result = result.to_i * 2
print result,"\n"

