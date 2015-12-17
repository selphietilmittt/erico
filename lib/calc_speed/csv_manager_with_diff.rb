
## ruby 2.2.0
## csv_manager_with_diff.rb

require "logger"
require "../util/csv_manager.rb"

class CSV_manager_with_diff < CSV_manager
	@diff
	@output_filename
	def initialize(target_filename, output_filename)
		@log = Logger.new("../../etc/log")
		@log.info("this is CSV_manager_with_diff initialize(" + target_filename + ")")
		super(target_filename)
		@diff = []
		@log.info("this is CSV_manager_with_diff initialize(" + output_filename + ")")
		@output_filename = output_filename
	end
	attr_accessor :diff
	
	
	def write_arrays_to_outputfile
		@log.info("write_arrays_to_outputfile")
		@log.info("output_filename :" + @output_filename)
		array = [@ranking, @name, @count, @diff]
		transposed_array = array.transpose
		#CSV.open(@output_filename, "a", encoding: "Shift_JIS") do |csv|
		CSV.open(@output_filename, "a", encoding: "CP932") do |csv|
					transposed_array.each do |row|
				csv << row
			end
			#csv << transposed_array
			#csv << transposed_array
			#csv << @ranking
			#csv << @name
			#csv << @count
			#csv << @diff
		end
	end
	
end

