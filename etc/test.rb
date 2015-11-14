
require "csv"

CSV.foreach("data/null-output.csv", encoding: "Shift_JIS:UTF-8") do |row|
	print row
end
