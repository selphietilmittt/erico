
## ruby
## csv_manager


print "csv_manager.rb start\n"
str = "this is" << "\n" + "csv_reader" * 2 + "\n"
print(str, "\n")

require "csv" 
require "logger" 

class CSV_manager
	# argument
	@@csv_line = []
	def initialize(target_filename)
		p "this is CSV_manager initialize(" + target_filename + ")"
		@@csv_filename = target_filename
	end
	
	def print_csv()
		print "CSV_manager.print(" + @@csv_filename + ")"	
		CSV.foreach(@@csv_filename, encoding: "Shift_JIS:UTF-7") do |row|
		#CSV.foreach("../../data/null-20151102-020006.csv") do |@row|
			print row
		end
	end

end


#CSV.foreach("data/null-output.csv", encoding: "Shift_JIS:UTF-8") do |row|
#	print row
#end


#csv_line_read02=[]
#csv_line_read01 = []
#CSV.open("data/null-output.csv")
#puts #(csv_line_read01)
#puts #(csv_line_read01[])

#arr = [123, 456, 789]
#puts csv_line_read01
