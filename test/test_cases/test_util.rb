

require '../../lib/util/util.rb'
@util = Util.new(File.basename(__FILE__).to_s)

begin
	puts File.basename(__FILE__).to_s + " start."
	@util.info ""
	@util.info File.basename(__FILE__).to_s + " start."
	@util.info ""

	#puts @util.getconf('NULL_FILELIST')
	#puts @util.get_toppickupnames
	
	file = File.open('test_util.txt','a+:Shift_JIS')
	file.add_to_target_line(',' + Time.now.to_s, 2)
	file.add_to_target_line(',' + Time.now.to_s, 5)
	file.close
	#create error
	#nil.puts

rescue => e
	@util.puts_write(e)
end


@util.info File.basename(__FILE__).to_s + " finished."
puts File.basename(__FILE__).to_s + " finished."
