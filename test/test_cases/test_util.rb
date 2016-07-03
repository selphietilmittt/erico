

require '../../lib/util/util.rb'
@util = Util.new(File.basename(__FILE__).to_s)

begin
	puts File.basename(__FILE__).to_s + " start."
	@util.info ""
	@util.info File.basename(__FILE__).to_s + " start."
	@util.info ""

	puts @util.getconf('NULL_FILELIST')
	puts @util.get_toppickupnames
	

	#create error
	nil.puts

rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
