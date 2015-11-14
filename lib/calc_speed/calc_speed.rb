
## ruby
## calc_speed.rb
p "calc_speed.rb"
require '../util/csv_manager.rb'

## main
previous_filename = ARGV[0]
following_filename= ARGV[1]
print following_filename,"-",previous_filename,"\n"

previous_file = CSV_manager.new(previous_filename)
previous_file.print_csv()

