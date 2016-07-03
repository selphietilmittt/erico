# encoding: Shift_JIS
#ruby
require 'kconv'
require '../../lib/util/util.rb'
require '../../lib/file/file_manager.rb'
@util = Util.new(File.basename(__FILE__).to_s)

require 'optparse'
opt = OptionParser.new
options = {}

# option parser
options[:output]                         = "stdout"
options[:calc_mode]             = ['latest']
opt.banner = " \
	TDL.\n \
	Usage: #{File.basename($0)} [options]\
	"

opt.on('-h','--help','show help') { print opt.help; exit }
opt.on( '-m calcmode','--calcmode','calculation mode. latest or all. default is "latest".',\
			Array){|v| options[:calc_mode] = v}
opt.permute!( ARGV )

begin
	puts File.basename(__FILE__).to_s + " start."
	@util.info ""
	@util.info File.basename(__FILE__).to_s + " start."
	@util.info ""

	calc_mode = options[:calc_mode][0]
	datadir = @util.getconf('DATADIR')
	outputdir = @util.getconf('OUTPUTDIR')
	outputfilename = @util.getconf('NULL_DEFEATING_NUM_FULLDATA')
	
	file_manager = File_manager.new()
	toppickupnames = @util.get_toppickupnames
	nums_of_toppickupname = {}
	bottompickupnames = @util.get_bottompickupnames
	nums_of_bottompickupname = {}
	
	
	if calc_mode == 'latest' then
		@util.info "calc_mode is latest"
		latest_filename = datadir + '/' + file_manager.get_latest_data_file + '.csv'
		latest_timestamp = file_manager.get_timestamp_of(latest_filename)

		if !File.exist?(outputfilename) then
			#initialize outputfile
			#fulldata_file = File.open(outputfilename, "w:sjis")
			num_array, name_array = file_manager.get_ranking_and_num_of(latest_filename)

			#get num of toppickupnames and bottompickupnames
			toppickupnames.each do |toppickupname|
				nums_of_toppickupname[toppickupname] = file_manager.get_num_of(toppickupname, name_array, num_array)
			end
			bottompickupnames.each do |bottompickupname|
				nums_of_bottompickupname[toppickupname] = file_manager.get_num_of(bottompickupname, name_array, num_array)
			end
			
			
		else
			#add latest data to outputfile
			fulldata_file = File.open(outputfilename, "a:sjis")
			fulldata_file.puts "add"
		
		end
		#
		#
		
		
	elsif calc_mode == 'all' then
		@util.info "calc_mode is all"
		fulldata_file = File.open(outputfilename, "w+:sjis")
		
		filelist = File.open(@util.getconf('NULL_FILELIST'), "r:sjis").each do |filename|
			filename = datadir+'/'+filename.chomp!+'.csv'
			timestamp = file_manager.get_timestamp_of(filename)
			puts timestamp
			File.open(filename, "r:sjis").each do |line|
			
			end
		end
		
	else
		@util.fatal "calc_mode[#{calc_mode}] error"
	end

rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
