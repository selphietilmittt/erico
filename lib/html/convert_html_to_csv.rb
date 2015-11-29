
#ruby
## convert html to csv
require '../util/util.rb'
require '../util/csv_converter.rb'


## main
@converter = CSV_converter.new(ARGV[0] ,ARGV[1])
@converter.read_html()