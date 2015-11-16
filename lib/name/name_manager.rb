
## ruby 2.2.0
## name_manager

require "logger"
require "../util/csv_manager.rb"

class NAME_manager
	#var
	@CSV_manager
	
	def initialize(csv_manager)
		@CSV_manager = csv_manager
	end
end

