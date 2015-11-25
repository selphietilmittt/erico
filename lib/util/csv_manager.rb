
## ruby
## csv_manager
require "csv"
require '../util/util.rb'

class CSV_manager
	# var
	@util
	@csv_filename
	@ranking
	@dani
	@count
	@name

	def initialize(target_filename)
		@util = Util.new("CSV_manager")
		@util.info("this is CSV_manager initialize(" + target_filename + ")")

		@csv_filename = target_filename
		@ranking=[]
		@dani=[]
		@name=[]
		@count=[]

		@util.info("csv_filename="+@csv_filename)
		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			@ranking.push row[0]
			@count.push row[1]
			@name.push row[2]
		end
	end
	attr_reader :ranking
	attr_reader :dani
	attr_reader :count
	attr_reader :name

	def parse_csv
		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			if(row.size == 3) then
				@util.info("parse_csv: row.size = 3 and push rankng, count, name")
				@ranking.push row[0]
				@count.push row[1]
				@name.push row[2]
			elsif(row.size == 4) then
				@util.info("parse_csv: row.size = 3 and push rankng, dani, count, name")
				@ranking.push row[0]
				@dani.push row[1]
				@count.push row[2]
				@name.push row[3]
			end
		end
	end

	
	def print_csv()
		@util.log.info("CSV_manager.print(" + @csv_filename + ")")
		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			@log.info( row )
		end
	end
	
	def print_ranking()
		@util.log.info("CSV_manager.print_ranking")
		p @ranking
	end

	def print_count()
		@util.log.info("CSV_manager.print_count")
		p @count
	end

	def print_name()
		@util.log.info("CSV_manager.print_name")
		p @name
	end


end

## main for test
#util = Util.new("Csv_manager main for test")
#util.info("Csv_manager main for test")
#csv_manager = CSV_manager.new("../../data/null-20151116-000003.csv")

#csv_manager = Csv_manager.
#str = "this is" << "\n" + "csv_reader" * 2 + "\n"
#print(str, "\n")

