
#ruby
require "csv"
require 'open-uri'
require 'nokogiri'
require '../util/util.rb'

class CSV_converter
	#var
	@util
	@input_filename
	@input_file
	@output_filename
	@output_file

	attr_reader :input_filename
	attr_reader :input_file
	attr_reader :output_filename
	attr_reader :output_file

	def initialize(input_filename, output_filename)
		@util = Util.new("CSV_converter")
		@input_filename = input_filename
		@output_filename = output_filename
		@util.info("convert\nfrom["+@input_filename+"]\nto["+@output_filename+"]")
	end
	
	#def read_input_file
	def read_html()
		@util.info("read_html["+ @input_filename + "]")
		if !File.exist?(@input_filename) then
			@util.fatal "input_file[#{@input_filename}] not exist."
		end
		input_file = File.open(@input_filename,'r:UTF-8', :invalid => :replace, :undef => :replace, :replace => '?')
		#input_file.encode('Shift_JIS', :invalid => :replace, :undef => :replace)
		@input_file=Nokogiri::HTML(input_file)
		@util.debug("@input_file.encoding[#{@input_file.encoding}]")

		#convert sjis to utf8
		@util.debug "convert sjis to utf8"
		@input_file.to_s.encode('Shift_JIS', :invalid => :replace, :undef => :replace)
		#@input_file.to_s.encode('UTF-8', :invalid => :replace, :undef => :replace)
		#@input_file.to_s.encode('Shift_JIS', :invalid => :replace, :undef => :replace)
		@util.debug "encoding:#{@input_file.encoding}"
		#@util.debug @input_file.to_s
	end

	def print_input_file()
		@util.info("print input_file "+ input_filename)
		print @input_file
	end

	##def read_***
end
