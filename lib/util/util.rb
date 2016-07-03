#!/usr/bin/ruby
## util
require "logger" 
require 'kconv'

class Util

	@log
	@config_file
	@called_by_

	def initialize(name)
		@log = Logger.new("../../etc/log")
		@log.level = Logger::DEBUG
		#@log.level = Logger::INFO
		#@log.level = Logger::WARN
		@log.info "--util.rb : util.initialize calld by " + name
		@config_file="../../etc/configure.txt"
		@called_by_=name
	end


	def debug(comment)
		@log.debug "called by "+@called_by_
		@log.debug comment
	end

	def info(comment)
		@log.info "called by "+@called_by_
		@log.info comment
	end

	def warning(comment)
		@log.warn "[WARN]called by "+@called_by_
		@log.warn "[WARN]#{comment}"
	end

	def fatal(comment)
		@log.fatal "[[FATAL]]called by "+@called_by_
		@log.fatal "[[FATAL]]#{comment}"
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

	def puts_write(error)
		puts error.backtrace
		puts error.message
		fatal( "#{error.backtrace}" )
		fatal( "#{error.message}" )
	end
	
	def get_toppickupnames
		info 'get_toppickupnames start.'
		toppickupnames_filename = getconf('PROFILE_TOPPICKUPNAME')
		debug "file[#{toppickupnames_filename}"
		toppickupnames = []
		File.open(toppickupnames_filename, 'r:sjis').each do |toppickupname|
			toppickupnames.push(Kconv.tosjis(toppickupname.chomp))
		end
		info "get_toppickupnames finished. return array[#{toppickupnames.size()}]."
		return toppickupnames
	end

	def get_bottompickupnames
		info 'get_bottompickupnames start.'
		bottompickupnames_filename = getconf('PROFILE_BOTTOMPICKUPNAME')
		debug "file[#{bottompickupnames_filename}"
		bottompickupnames = []
		File.open(bottompickupnames_filename, 'r:sjis').each do |bottompickupname|
			bottompickupnames.push(Kconv.tosjis(bottompickupname.chomp))
		end
		info "get_bottompickupnames finished. return array[#{bottompickupnames.size()}]."
		return bottompickupnames
	end
end
