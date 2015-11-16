
## ruby
## calc_speed.rb
require "logger"
require '../util/csv_manager.rb'
require '../name/name_manager.rb'
require '../calc_speed/calc_diff.rb'
require "../calc_speed/csv_manager_with_diff.rb"

## main
log = Logger.new("../../etc/log")
@previous_filename = ARGV[0]
@following_filename= ARGV[1]
@output_filename=ARGV[2]
log.info('--calc_speed.rb :main')
log.info "ARGV: " + @following_filename + " , " +@previous_filename + "\n"

@previous_file = CSV_manager.new(@previous_filename)
@following_file_with_diff=CSV_manager_with_diff.new(@following_filename, @output_filename)
@calc_diff=Calc_diff.new(@previous_file, @following_file_with_diff)
@calc_diff. calc_diff()
@calc_diff.following_file_with_diff.write_arrays_to_outputfile()
#return "filename"
