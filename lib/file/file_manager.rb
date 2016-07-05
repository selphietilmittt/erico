
#ruby
require '../../lib/util/util.rb'

class File_manager
	@util
	
	def initialize()
		@util = Util.new('File_manager')
	end
	
	def get_latest_data_file()
		#get last line of NULL_FILELIST
		File.open(@util.getconf('NULL_FILELIST'), 'r:sjis').each do |line|
			@last_line = line
		end
		return @last_line.chomp!
	end
	
	def get_timestamp_of(filename)
		#get timestamp of data/**-*********-******.csv
		#put on first line
		@util.info "get_timestamp_of(#{filename}) start."
		File.open(filename, 'r:sjis').each do |line|
			@timestamp = line.gsub(/,/,'')
			break
		end
		@util.info "get_timestamp_of(#{filename}) finished. return #{@timestamp}"
		return @timestamp
	end
	
	def get_ranking_and_num_of(filename)
		@util.info "get_ranking_and_num_of(#{filename}) start."
		num_array = []
		name_array = []
		ranking_flag = false
		File.open(filename, 'r:sjis').each do |line|
			if line == "#{@util.getconf('ALL_MEMBERS_HEAD')}\n" then
				ranking_flag = true
			elsif line == "#{@util.getconf('BOTTOMPICKUPNAME_HEAD')}\n" then
				ranking_flag = false
			end
			
			if ranking_flag then
				elements = line.split(',')
				if elements.size() ==4 then
					num_array.push(elements[3].chomp)
					name_array.push(Kconv.tosjis(elements[2]))
				end
			end
			
		end
		@util.info "get_ranking_and_num_of(#{filename}) finished. return num_array and name_array, which sizes are [#{num_array.size}]"
		return num_array, name_array
	end
	
	def get_num_of(target_name, name_array, num_array)
		@util.debug "get num of #{target_name}"
		@util.debug "num_array.size=#{num_array.size}"
		for ranking in 0..num_array.size-1
			if name_array[ranking].match(target_name) then
				@util.debug "target_name[#{target_name}], ranking[#{ranking}], name[#{name_array[ranking]}], num[#{num_array[ranking]}]"
				return num_array[ranking]
			end
		end
	end
		
end
