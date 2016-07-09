
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

	num_array_of_ranking, name_array_of_ranking = file_manager.get_ranking_and_num_of(latest_filename)
	toppickupnames = @util.get_toppickupnames
	speed_of_toppickupname = {}
	defeating_num_of_toppickupname = {}
	nums_of_toppickupname = {}
	num_array_of_ranking, name_array_of_ranking = file_manager.get_ranking_and_num_of(latest_filename)

	
				toppickupnames.each do |toppickupname|
					nums_of_toppickupname[toppickupname] = file_manager.get_num_of(toppickupname, name_array_of_ranking, num_array_of_ranking)
					defeating_num[toppickupname], ave[toppickupname] = speed_manager.get_speed_and_defeating_num_of(toppickupname, latest_filename)
				end


rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
