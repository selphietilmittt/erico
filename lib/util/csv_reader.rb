

print "readcsv.rb start\n"
str = "this is" << "\n" + "csv_reader" * 2 + "\n"
print(str, "\n")

require "csv" 
require "logger" 




CSV.foreach("data/null-output.csv", encoding: "Shift_JIS:UTF-8") do |row|
	print row
end


#csv_line_read02=[]
#csv_line_read01 = []
#CSV.open("data/null-output.csv")
#puts #(csv_line_read01)
#puts #(csv_line_read01[])

#arr = [123, 456, 789]
#puts csv_line_read01

print "\nend\n"
