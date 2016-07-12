# encoding: UTF-8
#ruby
## convert html to csv
require '../util/util.rb'
require '../util/csv_converter.rb'
require '../util/csv_manager.rb'

@util = Util.new("convert_html_to_csv.rb")
if ARGV.size != 2 then;@util.fatal("ARGV.size not equal 2");end
@input_filename=ARGV[0]
@output_filename=ARGV[1]
@util.info("this is convert_html_to_csv.rb input[" + @input_filename +"] to output[" + @output_filename+"]")

## main
@util.debug 'convert_html_to_csv.rb main start.'
@output_file=CSV_manager.new(@output_filename)
@converter = CSV_converter.new(@input_filename ,@output_filename)
@util.debug '@converter.read_html'
@converter.read_html
@util.debug "@converter.input_file.encoding[#{@converter.input_file.encoding}]"
@user_array=@converter.input_file.xpath("//div").css('.ranking_area')

@user_array.each do |user|
	@output_file.ranking.push user.css('.rank').text.chomp
	@output_file.dani.push user.css("#dani").css(".rank_user").text.chomp
	@user_name = user.css("#name").css(".rank_user").text.chomp
	@user_name.gsub!(" ","_")
	#print "user_name[" + @user_name + "]\n"
	@output_file.name.push @user_name
	#@output_file.name.push user.css("#name").css(".rank_user").text.chomp
	@output_file.count.push user.css('.progress_icon_b').text.chomp
end
#@output_file.print_name
@output_file.output_csv