#!/usr/bin/ruby
## convert html to csv
require '../util/util.rb'

module Convert_html_to_csv
	def self.convert_html_to_csv(target_html_name output_csv_name)
		util = Util.new("Convert_html_to_csv.convert_html_to_csv")
		p target_html_name
		p output_csv_name
	end
end


## test
Convert_html_to_csv.convert_html_to_csv(ARGV[0] ARGV[1])