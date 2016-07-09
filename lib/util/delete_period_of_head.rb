# encoding: Shift_JIS
#ruby
require '../../lib/util/util.rb'
require '../../lib/file/file_manager.rb'

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
	
	filelist = File.open(@util.getconf('NULL_FILELIST'), "r:Shift_JIS")		
	if filelist.size == 0
		@util.info "nothing to do"
	else
		filelist.each do |filename|
			file = File.open(datadir + '/' + filename.chomp + '.csv', "a+:Shift_JIS")
			file_array = file.readlines
			for i in 0..file_array.size-1
				if file_array[i].include?('ALL,') then
					puts file_array[i]
				end
			end
		end
	end


rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
