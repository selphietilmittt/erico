
## ruby 2.2.0
## calc_diff.rb

require "logger"
require "../util/csv_manager.rb"
require "../calc_speed/csv_manager_with_diff.rb"

class Calc_diff
	#argv: csv_manager::previous_file,csv_manager_with_diff::following_file
	
	# var
	@log
	@previous_file # CSV_manager
	@following_file_with_diff #  CSV_manager_with_diff
	
	def initialize(previous_file, following_file_with_diff)
		@log = Logger.new("../../etc/log")
		@log.info("this is Calc_diff initialize()")
		@previous_file = previous_file
		@following_file_with_diff = following_file_with_diff
	end
	
	attr_accessor :following_file_with_diff

	def get_previous_count(following_name)
		#@log.info("get_previous_count(" + following_name + ")")
		i = 0
		for previous_name in @previous_file.name do
			if following_name == previous_name then
				#@log.info("following_name: " + following_name + ", previous_name: " + previous_name)
				#@log.info("@previous_file.count[" + i.to_s + "] = " + @previous_file.count[i])
				return @previous_file.count[i]
			end
			i = i + 1
		end
		## no matching
		return "out_of_rank"
	end
	
	def calc_diff
		@log.info("calc_diff")
		i = 0
		for following_name in @following_file_with_diff.name do
			previous_count = get_previous_count(following_name)
			following_count = @following_file_with_diff.count[i]
			#@log.info("@following_count = " + following_count )		
			if previous_count == "out_of_rank" then
				#@log.info("@following_file_with_diff.diff.push(out_of_rank)")
				@following_file_with_diff.diff.push("out_of_rank")
			else
				diff = following_count.to_i - previous_count.to_i
				#@log.info("diff = " + diff.to_s)
				@following_file_with_diff.diff.push(diff.to_s)
			end
			i = i + 1	
		end
	end
	
	# print
	def print_previous_ranking()
		@previous_file.print_ranking()
	end
	def print_previous_count()
		@previous_file.print_count()
	end
	def print_previous_name()
		@previous_file.print_name()
	end
	def print_following_ranking()
		@following_file.print_ranking()
	end
	def print_following_count()
		@following_file.print_count()
	end
	def print_following_name()
		@following_file.print_name()
	end

end
