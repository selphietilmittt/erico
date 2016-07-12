# encoding: UTF-8
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
		#if csv_filename not exiest fatal
		#CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
		CSV.foreach(@csv_filename, encoding: "CP932:UTF-8") do |row|
			#print "row[0]:" + row[0] + ", row[1]:" + row[1] + ", row[2]:" + row[2] + ", row[3]:" + row[3] + "\n"
			@ranking.push row[0]
			@dani.push row[1]
			@name.push row[2]
			@count.push row[3]
		end
	end
	attr_reader :ranking
	attr_reader :dani
	attr_reader :count
	attr_reader :name

	def output_csv()
		if(@dani.empty?) then
			p @ranking.size
		else
			#output_array= [@ranking, @dani, @name, @count]
			output_array= [@ranking, @dani, @name, @count]
			transposed_array = output_array.transpose
			CSV.open(@csv_filename, "a", encoding: "UTF-8") do |csv|
				transposed_array.each do |line|
					csv << line
				end
			end
		end
			#CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			#if(row.size == 3) then
			#	@util.info("output_csv: row.size = 3 and write rankng, count, name")
			#elsif(row.size == 4) then
			#	@util.info("output_csv: row.size = 3 and write rankng, dani, count, name")
			#end
		#end
	end

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
		@util.info("CSV_manager.print(" + @csv_filename + ")")
		CSV.foreach(@csv_filename, encoding: "Shift_JIS:UTF-8") do |row|
			@log.info( row )
		end
	end
	
	def print_ranking()
		@util.info("CSV_manager.print_ranking")
		print @ranking
	end

	def print_dani()
		@util.info("CSV_manager.print_name")
		print @dani
	end

	def print_name()
		@util.info("CSV_manager.print_name")
		print @name
	end

	def print_count()
		@util.info("CSV_manager.print_count")
		print @count
	end



end

## main for test
#util = Util.new("Csv_manager main for test")
#util.info("Csv_manager main for test")
#csv_manager = CSV_manager.new("../../data/null-20151116-000003.csv")

#csv_manager = Csv_manager.
#str = "this is" << "\n" + "csv_reader" * 2 + "\n"
#print(str, "\n")

