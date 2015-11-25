
## ruby
## calc_speed.rb
require '../util/util.rb'
require '../util/csv_manager.rb'
#require '../calc_speed/calc_diff.rb'
require "../calc_speed/csv_manager_with_diff.rb"

## main
@util = Util.new("calc_speed.rb")
@previous_filename = ARGV[0]
@following_filename= ARGV[1]
@output_filename=ARGV[2]
@util.info('--calc_speed.rb :main')
@util.info "ARGV: " + @following_filename + " , " +@previous_filename + "\n"

@previous_file = CSV_manager.new(@previous_filename)
@following_file_with_diff=CSV_manager_with_diff.new(@following_filename, @output_filename)
@calc_diff=Calc_diff.new(@previous_file, @following_file_with_diff)
@calc_diff. calc_diff()
@calc_diff.following_file_with_diff.write_arrays_to_outputfile()
