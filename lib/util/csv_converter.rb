
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
		#if input_filename not exist. fatal
		@input_file=Nokogiri::HTML(File.open(@input_filename))
	end

	def print_input_file()
		@util.info("print input_file "+ input_filename)
		print @input_file
	end

	##def read_***
end
