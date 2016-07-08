# encoding: Shift_JIS
#ruby
require '../../lib/util/util.rb'

class File_manager
	@util
	
	def initialize()
		@util = Util.new('File_manager')
	end
	
	def get_latest_data_file()
		#get last line of NULL_FILELIST
		File.open(@util.getconf('NULL_FILELIST'), 'r:Shift_JIS').each do |line|
			@last_line = line
		end
		return @last_line.chomp!
	end
	
	def get_timestamp_of(filename)
		#get timestamp of data/**-*********-******.csv
		#put on first line
		@util.info "get_timestamp_of(#{filename}) start."
		File.open(filename, 'r:Shift_JIS').each do |line|
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
		File.open(filename, 'r:Shift_JIS').each do |line|
			if line == "#{@util.getconf('ALL_MEMBERS_HEAD')}\n" then
				ranking_flag = true
			elsif line == "#{@util.getconf('BOTTOMPICKUPNAME_HEAD')}\n" then
				ranking_flag = false
			end
			
			if ranking_flag then
				@util.debug "elements[#{line}]"
				elements = line.scrub.split(',')
				if elements.size() ==4 then
					num_array.push(elements[3].chomp)
					name_array.push(Kconv.tosjis(elements[2]))
				end
			end
			
		end
		@util.info "get_ranking_and_num_of(#{filename}) finished. return num_array and name_array, which sizes are [#{num_array.size}]"
		return num_array, name_array
	end
	
	def get_border_and_num_of(filename)
		@util.info "get_border_and_num_of(#{filename}) start."
		num_array = {}
		name_array = []
		border_flag = false
		File.open(filename, 'r:Shift_JIS').each do |line|
			if line == "#{@util.getconf('BORDER_HEAD')}\n" then
				border_flag = true
			elsif !line.match('位') then
				border_flag = false
			end
			
			if border_flag then
				elements = line.split(',')
				if elements.size() ==4 then
					num_array[Kconv.tosjis(elements[2])] = elements[3].chomp
					name_array.push(Kconv.tosjis(elements[2]))
				end				
			end
		end
		@util.info "get_border_and_num_of(#{filename}) finished. return num_array and name_array, which sizes are [#{num_array.size}]"
		return num_array, name_array
	end
	
	def get_num_of(target_name, name_array, num_array)
		@util.debug "get num of #{target_name.encode('UTF-8')}"
		@util.debug "num_array.size=#{num_array.size}"
		for ranking in 0..num_array.size-1
			if name_array[ranking].match(target_name) then
				@util.debug "target_name[#{target_name.encode('UTF-8')}], ranking[#{ranking}], name[#{name_array[ranking].encode('UTF-8')}], num[#{num_array[ranking]}]"
				return num_array[ranking]
			end
		end
	end
	
	def remove_name_at_ranking_of_fulldata(fulldata_file)
		@util.info "remove_name_at_ranking_of_fulldata start."
		#read
		fulldata_file.seek(0, IO::SEEK_SET)
		file = fulldata_file.readlines

		#initialize
		fulldata_file.truncate(0)
		
		#replace
		start_line = @util.getconf('START_OF_RANKING').to_i
		end_line = @util.getconf('END_OF_RANKING').to_i
		for i in start_line-1..end_line-1
			elements = file[i].split(',')
			elements.pop
			if elements.size == 0 then
				@util.fatal "elements.size == nil"
			else
				for j in 0..elements.size-1
					str = elements[0] if j == 0
					str = str + ',' + elements[j].to_s if j != 0
				end
			end
			file[i] = str+"\n"
		end

		#write
		file.each do |line|
			@util.debug "line[#{line}]"
			fulldata_file.write line
		end
		
		#reset Enumlator
		fulldata_file.seek(0, IO::SEEK_SET)
		@util.info "remove_name_at_ranking_of_fulldata finished."
	end
	
	#slow
	def add_timestamp_to_fulldata(fulldata_file, timestamp)
		@util.info "add_timestamp_to_fulldata start."
		@util.info "add timestamp[#{timestamp}] to fulldata."
		start_line = @util.getconf('TIMESTAMP').to_i
		
		fulldata_file.add_to_target_line(','+timestamp.chomp, start_line)
		@util.info "add_timestamp_to_fulldata finished."
	end

	#Fast
	def add_timestamp_to_fulldata_array(fulldata_array, timestamp)
		@util.info "add_timestamp_to_fulldata start."
		@util.info "add timestamp[#{timestamp}] to fulldata."
		start_line = @util.getconf('TIMESTAMP').to_i
		
		fulldata_array[start_line -1] = fulldata_array[start_line -1].chomp + ',' + timestamp.chomp
		@util.info "add_timestamp_to_fulldata finished."
	end

	
	#slow
	def add_toppickupnames_to_fulldata(fulldata_file, toppickupnames, nums_of_toppickupname, speed, defeating_num)
		@util.info "add_toppickupnames_to_fulldata start."
		@util.info "add toppickupnames[#{toppickupnames.size()}] to fulldata."
		#how to write to target line?
		line_num = @util.getconf('START_OF_TOP_PICKUP_NAME').to_i
		toppickupnames.each do |name|
			fulldata_file.add_to_target_line(','+nums_of_toppickupname[name].chomp, line_num)
			line_num +=1
			fulldata_file.add_to_target_line(','+speed[name].chomp, line_num) if speed[name] != nil
			line_num +=1
			fulldata_file.add_to_target_line(','+defeating_num[name].chomp, line_num) if defeating_num[name] != nil
			line_num +=1
			
		end

		@util.info "add_toppickupnames_to_fulldata finished."		
	end
	
	#Fast
	def add_toppickupnames_to_fulldata_array(fulldata_array, toppickupnames, nums, speed, defeating_num)
		@util.info "add_toppickupnames_to_fulldata_array start."
		@util.info "add toppickupnames[#{toppickupnames.size()}] to fulldata."
		
		if @util.getconf('NUM_OF_TOP_NAME').to_i > 0
			line_num = @util.getconf('START_OF_TOP_PICKUP_NAME').to_i - 1
			toppickupnames.each do |name|
				@util.debug "name[#{name}]"
				fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].chomp + nums[name].to_s if nums[name] != nil
				line_num += 1
				fulldata_array[line_num] = fulldata_array[line_num].to_s.chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].to_s.chomp + speed[name].to_s if speed[name] != nil
				line_num += 1
				fulldata_array[line_num] = fulldata_array[line_num].to_s.chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].to_s.chomp + defeating_num[name].to_s if defeating_num[name] != nil
				line_num +=1
			end
			@util.info "add_toppickupnames_to_fulldata_array finished."
		else
			@util.info "add_toppickupnames_to_fulldata_array finished. Nothing to do."
		end

	end
	
	#slow
	def add_ranking_to_fulldata(fulldata_file, ranking, nums)
		@util.info "add_ranking_to_fulldata start."
		start_line = @util.getconf('START_OF_RANKING').to_i
		end_line = @util.getconf('END_OF_RANKING').to_i
		
		for i in 0..ranking.size-1
			fulldata_file.add_to_target_line(",#{nums[i]},#{ranking[i]}", start_line+i)
		end
		
		@util.info "add_ranking_to_fulldata finished."
	end

	#Fast
	def add_ranking_to_fulldata_array(fulldata_array, ranking, nums)
		@util.info "add_ranking_to_fulldata_array start."
		start_line = @util.getconf('START_OF_RANKING').to_i - 1
		end_line = @util.getconf('END_OF_RANKING').to_i - 1
		
		for i in 0..ranking.size-1
			fulldata_array[start_line + i] = fulldata_array[start_line + i].chomp + ",#{nums[i]}"
		end
		
		@util.info "add_ranking_to_fulldata_array finished."
	end
	
	#Fast
	def add_names_of_ranking_to_fulldata_array(fulldata_array, ranking, nums)
		@util.info "add_ranking_to_fulldata_array start."
		start_line = @util.getconf('START_OF_RANKING').to_i - 1
		end_line = @util.getconf('END_OF_RANKING').to_i - 1
		
		for i in 0..ranking.size-1
			fulldata_array[start_line + i] = fulldata_array[start_line + i].chomp + ",#{ranking[i]}"
		end
		
		@util.info "add_ranking_to_fulldata_array finished."
	end

	#Fast
	def add_bottompickupnames_to_fulldata_array(fulldata_array, bottompickupnames, nums, speed, defeating_num)
		@util.info "add_bottompickupnames_to_fulldata_array start."
		@util.info "add bottompickupnames[#{bottompickupnames.size()}] to fulldata."

		if @util.getconf('NUM_OF_BOTTOM_NAME').to_i > 0
			line_num = @util.getconf('START_OF_BOTTOM_PICKUP_NAME').to_i - 1
			bottompickupnames.each do |name|
				fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].chomp + nums[name] if nums[name] != nil
				line_num += 1
				fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].chomp + speed[name] if speed[name] != nil
				line_num += 1
				fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
				fulldata_array[line_num] = fulldata_array[line_num].chomp + defeating_num[name] if defeating_num[name] != nil
				line_num +=1
			end
			@util.info "add_bottompickupnames_to_fulldata_array finished."
		else
			@util.info "add_bottompickupnames_to_fulldata_array finished. Nothing to do."
		end
	end

	def add_borders_to_fulldata_array(fulldata_array, borders, nums, speed, defeating_num)
		@util.info "add_borders_to_fulldata_array start."
		@util.info "add borders[#{borders.size()}] to fulldata."
		start_line = @util.getconf('START_OF_BORDER').to_i - 1
		end_line = @util.getconf('END_OF_BORDER').to_i - 1
		
		line_num = start_line
		borders.each do |name|
			fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
			fulldata_array[line_num] = fulldata_array[line_num].chomp + nums[name] if nums[name] != nil
			line_num += 1
			fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
			fulldata_array[line_num] = fulldata_array[line_num].chomp + speed[name] if speed[name] != nil
			line_num += 1
			fulldata_array[line_num] = fulldata_array[line_num].chomp + ','
			fulldata_array[line_num] = fulldata_array[line_num].chomp + defeating_num[name] if defeating_num[name] != nil
			line_num +=1
		end

		@util.info "add_borders_to_fulldata_array Finished."
	end
end
