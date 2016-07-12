# encoding: UTF-8
#ruby
require '../../lib/util/util.rb'

class Speed_manager
	@util
	
	def initialize()
		@util = Util.new('Speed_manager')
	end

	def get_speed_and_defeating_num_of(name, following_filename)
		@util.info "get_speed_and_defeating_num_of(#{name}) start."
		@util.debug "following_filename[#{following_filename}]"
		timeslot = @util.getconf('TIMESLOT')
		ave_range=@util.getconf('AVE_RANGE')
		
		file_manager = File_manager.new()
		following_num_array, following_name_array = file_manager.get_ranking_and_num_of(following_filename)
		following_num = file_manager.get_num_of(name, following_name_array, following_num_array)
		@util.debug "following_num[#{following_num}]"
		
		previous_filename = @util.get_previous_filename(following_filename, timeslot)
		@util.debug "following_filename[#{following_filename}],previous_filename[#{previous_filename}]"
		if previous_filename.nil? then
			@util.info "previous_filename is nil."
			@util.info "get_speed_and_defeating_num_of(#{name}) finished.return file_not_found"
			return "file_not_found","file_not_found"
		end
		previous_num_array, previous_name_array = file_manager.get_ranking_and_num_of(previous_filename)
		previous_num = file_manager.get_num_of(name, previous_name_array, previous_num_array)
		@util.debug "previous_num[#{previous_num}]"
		if previous_num.nil? then
			@util.info "get_speed_and_defeating_num_of(#{name}) finished.return out_ot_rank"
			return "out_ot_rank","out_ot_rank"
		end

		defeating_num = following_num.to_i - previous_num.to_i
		@util.info "defeating_num[#{defeating_num}]"
			
		ave = following_num.to_i - previous_num.to_i
		for i in 1..ave_range.to_i - 1
			shifted_following_filename = @util.get_previous_filename(following_filename, i)
			@util.debug "shifted_following_filename[#{shifted_following_filename}]"
			if shifted_following_filename.nil? then
				@util.info "get_speed_and_defeating_num_of(#{name}) finished.return file_not_found"
				return "file_not_found","file_not_found"
			end
			shifted_following_num_array, shifted_following_name_array = file_manager.get_ranking_and_num_of(shifted_following_filename)
			shifted_following_num = file_manager.get_num_of(name, shifted_following_name_array, shifted_following_num_array)
			
			@util.debug "shifted_following_num[#{shifted_following_num}]"
			if shifted_following_num.nil? then
				@util.info "get_speed_and_defeating_num_of(#{name}) finished.return out_ot_rank"
				return "out_ot_rank","out_ot_rank"
			end
			ave += shifted_following_num.to_i

			shifted_previous_filename = @util.get_previous_filename(shifted_following_filename, timeslot)
			if shifted_previous_filename.nil? then
				@util.info "get_speed_and_defeating_num_of(#{name}) finished.return file_not_found"
				return "file_not_found","file_not_found"
			end
			@util.debug "shifted_previous_filename[#{shifted_previous_filename}]"
			shifted_previous_num_array, shifted_previous_name_array = file_manager.get_ranking_and_num_of(shifted_previous_filename)
			shifted_previous_num = file_manager.get_num_of(name, shifted_previous_name_array, shifted_previous_num_array)
			@util.debug "shifted_previous_num[#{shifted_previous_num}]"
			if shifted_previous_num.nil? then
				@util.info "get_speed_and_defeating_num_of(#{name}) finished.return out_ot_rank"
				return "out_ot_rank","out_ot_rank"
			end
			ave -= shifted_previous_num.to_i
		end
		ave = ave/ave_range.to_f		
		
		@util.info "get_speed_and_defeating_num_of(#{name}) finished.return defeating_num[#{defeating_num}],ave[#{ave}]"
		return defeating_num,ave
	end
	
	def get_speed_and_defeating_num_of_border(border_names, latest_filename)
		return {}, {}
	end
end