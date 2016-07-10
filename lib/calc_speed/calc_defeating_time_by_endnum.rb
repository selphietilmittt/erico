
#ruby
require 'kconv'
require '../../lib/util/util.rb'
require '../../lib/file/file_manager.rb'
require '../../lib/calc_speed/speed_manager.rb'

@util = Util.new(File.basename(__FILE__).to_s)

require 'optparse'
opt = OptionParser.new
options = {}

# option parser
options[:output]                         = "stdout"
options[:calc_mode]             = ['latest']
opt.banner = " \
	TDL.\n \
	Usage: #{File.basename($0)} [options]\
	"

opt.on('-h','--help','show help') { print opt.help; exit }
opt.on( '-m calcmode','--calcmode','calculation mode. latest or all. default is "latest".',\
			Array){|v| options[:calc_mode] = v}
opt.permute!( ARGV )

begin
