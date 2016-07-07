
class String
  def sjisable
    str = self
    str = str.exchange("U+301C", "U+FF5E")
    str = str.exchange("U+2212", "U+FF0D")
    str = str.exchange("U+00A2", "U+FFE0")
    str = str.exchange("U+00A3", "U+FFE1")
    str = str.exchange("U+00AC", "U+FFE2")
    str = str.exchange("U+2014", "U+2015")
    str = str.exchange("U+2016", "U+2225")
    str = str.exchange("U+FFFD", "U+30FB")
  end

  def exchange(before_str,after_str)
    self.gsub( before_str.to_code.chr('UTF-8'),
                after_str.to_code.chr('UTF-8') )
  end

  def to_code
    return $1.to_i(16) if self =~ /U\+(\w+)/
    raise ArgumentError, "Invalid argument: #{self}"
  end
end


	@wave
	File.open('null-20160705-133532.csv', 'r:sjis').each do |line|
		@sjis = line
		#puts @sjis.encode('UTF-8').sjisable.encode('UTF-8')
		puts @sjis.encode('Shift_JIS', :invalid => :replace, :undef => :replace)
		@wave = line
	end
	#str = sjis_safe("`") #.encode(Encoding::SJIS)
	#str = ("`")
	#str = sjis_safe("`")
  #puts str
