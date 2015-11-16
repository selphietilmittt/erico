
## ruby
## csv_manager
require "csv" 
require "logger" 

class CSV_manager
	# var
	@log
	@csv_filename
	@ranking
	@count
	@name

	def initialize(target_filename)
		@log = Logger.new("../../etc/log")
		@log.info("this is CSV_manager initialize(" + target_filename + ")")
		@csv_filename = target_filename
		@ranking=[]
		@name=[]
		@count=[]

		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			@ranking.push row[0]
			@count.push row[1]
			@name.push row[2]
		end
	end
	attr_reader :ranking
	attr_reader :count
	attr_reader :name
	
	def print_csv()
		@log.info("CSV_manager.print(" + @csv_filename + ")")
		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			@log.info( row )
		end
	end
	
	def print_ranking()
		@log.info("CSV_manager.print_ranking")
		p @ranking
	end

	def print_count()
		@log.info("CSV_manager.print_count")
		p @count
	end

	def print_name()
		@log.info("CSV_manager.print_name")
		p @name
	end


end


#str = "this is" << "\n" + "csv_reader" * 2 + "\n"
#print(str, "\n")

