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
		@log.info "--util.rb : util.initialize calld by " + name
		@config_file="../../etc/configure.txt"
		log_level = getconf('LOG_LEVEL')
		case log_level
		when 'DEBUG' then @log.level = Logger::DEBUG
		when 'INFO' then @log.level = Logger::INFO
		when 'WARN' then @log.level = Logger::WARN
		when 'ERROR' then @log.level = Logger::ERROR
		when 'FATAL' then @log.level = Logger::FATAL
		end
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
		@log.info "--util.rb : util.getconf(" + target + ") "
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

class File
	def add_to_target_line(str, line_num)
		@util = Util.new('File')
		@util.info "File.add_to_target_line(#{line_num})"
		
		#read
		seek(0, IO::SEEK_SET)
		file = readlines
		str = file[line_num-1].to_s.chomp + str +"\n"
		@util.debug "file.size[#{file.size}]"
		@util.debug "file[#{line_num-1}]=#{file[line_num-1]}"
		@util.debug "str[#{str}]"
		
		#initialize
		truncate(0)
		
		#replace and write
		file[line_num-1] = str
		file.each do |line|
			@util.debug "line[#{line}]"
			write line
		end
		
		#offset = 0
		#seek(0, IO::SEEK_SET)
		#lf_counter = 0
		#until lf_counter >= line_num-1
		#	break if offset > size
		#	offset += 1
		#	chr = read(1)
		#	lf_counter += 1 if (chr != "\n" && offset == -1) || chr == "\n"
		#	@util.debug ("lf_counter[#{lf_counter}], offset[#{offset}]")
		#end

		#seek(offset, IO::SEEK_SET)
		#str = readline.chomp + str.to_s
		#@util.debug "str[#{str.chomp}]"
		#IO::write(path, str, offset)
		##File.binwrite(path, str, offset)
		##puts str
	end
		
	def next_line()
		@util = Util.new('File')
		offset = 0
		lf_counter = 0
		until lf_counter > 0
			offset += 1
			chr = read(1)
			lf_counter += 1 if (chr != "\n" && offset == -1) || chr == "\n"
		end

		seek(offset, IO::SEEK_SET)
	end
end
