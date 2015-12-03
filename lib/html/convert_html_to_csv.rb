
#ruby
## convert html to csv
require '../util/util.rb'
require '../util/csv_converter.rb'
require '../util/csv_manager.rb'

@util = Util.new("convert_html_to_csv.rb")
if ARGV.size != 2 then;@util.fatal("ARGV.size not equal 2");end
@input_filename=ARGV[0]
@output_filename=ARGV[1]

## main
@output_file=CSV_manager.new(@output_filename)
@converter = CSV_converter.new(@input_filename ,@output_filename)
@converter.read_html
@user_array=@converter.input_file.xpath("//div").css('.ranking_area')

@user_array.each do |user|
	@output_file.ranking.push user.css('.rank').text.chomp
	#print @output_file.ranking.push user.css('#dani').css('.rank_user').text.chomp
	#@output_file.dani.push user.css('.dani').text.chomp
	@output_file.name.push user.css('.name').text.chomp
	print user.xpath('tr/td/p[@class="rank_user"]').text
	@output_file.count.push user.css('.progress_icon_b').text.chomp
end
#@output_file.print_name
#@output_file.output_csv