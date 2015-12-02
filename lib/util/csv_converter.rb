
#ruby
## convert html to csv
require "csv"
require 'open-uri'
require 'nokogiri'
require '../util/util.rb'

class CSV_converter
	#var
	@util
	@input_filename
	@output_filename
	@input_file
	@output_file

	def initialize(input_filename, output_filename)
		@util = Util.new("CSV_converter")
		@input_filename = input_filename
		@output_filename = output_filename
		@util.info("convert\nfrom["+@input_filename+"]\nto["+@output_filename+"]")
	end

	def read_html()
		@util.info("read_html["+ @input_filename + "]")
		File.open(@input_filename) do |f|
  			@input_file=Nokogiri::HTML(f)
  		end

		# タイトルを表示
		p @input_file.title
	end

	##def read_***
end
