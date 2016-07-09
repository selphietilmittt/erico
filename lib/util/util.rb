#!/usr/bin/ruby
## util
require "logger" 
require 'kconv'
require 'date'

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
	
	def get_previous_filename(following_filename, time)
	#when filename is /home/alladmin/f/program/puyoque/erico/data/null-20160630-210201.csv
	#and time is 60, return null-20160630-2002
		info "time_calculator start.calc (#{following_filename} - #{time})"
		filedir = following_filename.split('.')[0].split('/')
		file_target, file_date, file_time = filedir[filedir.size()-1].split('-')
		if file_date.size !=8
			fatal "file_date[#{file_date}].size !=8"
		end
		if file_time.size !=6
			fatal "file_time[#{file_time}].size !=8"
		end
		
		year = file_date[0..3]
		month = file_date[4..5]
		date = file_date[6..7]
		
		hour = file_time[0..1]
		min = file_time[2..3]
		sec = file_time[4..5]
		debug "#{year},#{month},#{date},#{hour},#{min},#{sec}"
		
		require 'date'
		following_datetime = DateTime.new(year.to_i,month.to_i,date.to_i,hour.to_i,min.to_i,sec.to_i)
		#get previous file time
		previous_datetime = following_datetime - Rational(time, 24*60)
		debug "#{following_datetime} - #{time} = #{previous_datetime}"
		previous_filename = previous_datetime.strftime("%Y%m%d-%H%M")
		info "time_calculator finished. return #{previous_filename}"
		filedir.pop #remove filename to extract dirname
		filedir_str = ""
		filedir.each do |dir| filedir_str=filedir_str + dir + "/" end
		#puts filedir_str
		File.open(getconf('NULL_FILELIST'), 'r:Shift_JIS').each do |line|
			line.chomp!
			debug "#{line}.include?(#{previous_filename})"
			if line.include?(previous_filename) then
				info "time_calculator finished. return #{filedir_str+line+'.csv'}"
				return filedir_str+line+'.csv'
			end
		end
		
		info "time_calculator finished. not hit. return nil"
		return nil
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
