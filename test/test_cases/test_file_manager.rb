
require '../../lib/util/util.rb'
require '../../lib/file/file_manager.rb'
@util = Util.new(File.basename(__FILE__).to_s)

begin
	puts File.basename(__FILE__).to_s + " start."
	@util.info ""
	@util.info File.basename(__FILE__).to_s + " start."
	@util.info ""
	
	file_manager = File_manager.new()
	puts file_manager.get_latest_data_file
	
rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
