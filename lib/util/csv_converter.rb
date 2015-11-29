
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
		charset = nil
		@html = open(@input_filename) do |f|
  			charset = f.charset # 文字種別を取得
  			f.read # htmlを読み込んで変数htmlに渡す
  		end
		# htmlをパース(解析)してオブジェクトを生成
		doc = Nokogiri::HTML.parse(html, nil, charset)

		# タイトルを表示
		p doc.title
	end

	##def read_***
end
