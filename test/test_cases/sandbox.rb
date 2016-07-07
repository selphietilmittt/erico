# encoding: Shift_JIS

def sjis_safe(str)
  [
    ["301C", "FF5E"], # wave-dash
    ["2212", "FF0D"], # full-width minus
    ["00A2", "FFE0"], # cent as currency
    ["00A3", "FFE1"], # lb(pound) as currency
    ["00AC", "FFE2"], # not in boolean algebra
    ["2014", "2015"], # hyphen
    ["2016", "2225"], # double vertical lines
  ].inject(str) do |s, (before, after)|
    s.gsub(
      before.to_i(16).chr('UTF-8'),
      after.to_i(16).chr('UTF-8'))
  end
end
	str = sjis_safe("～").encode(Encoding::SJIS)
  puts str
