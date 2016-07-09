
#ruby
require '../../lib/util/util.rb'
require '../../lib/file/file_manager.rb'
require '../../lib/calc_speed/speed_manager.rb'

@util = Util.new(File.basename(__FILE__).to_s)
begin
	puts File.basename(__FILE__).to_s + " start."
	@util.info ""
	@util.info File.basename(__FILE__).to_s + " start."
	@util.info ""

	datadir = @util.getconf('DATADIR')
	outputdir = @util.getconf('OUTPUTDIR')
	outputfilename = @util.getconf('NULL_DEFEATING_NUM_FULLDATA')
	
	file_manager = File_manager.new()
	speed_manager = Speed_manager.new()
	latest_filename = datadir + '/' + file_manager.get_latest_data_file + '.csv'
	latest_timestamp = file_manager.get_timestamp_of(latest_filename)

	num_of_bordername, border_names = file_manager.get_border_and_num_of(latest_filename)
	defeating_num_of_border = {}
	ave_of_border = {}
	
	border_names.each do |name|
		puts name
	end

rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
