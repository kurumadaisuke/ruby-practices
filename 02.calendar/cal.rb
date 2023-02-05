require 'date'
require 'optparse'

today_year = Date.today.year
today_month = Date.today.month

opt = OptionParser.new
option = {}
opt.on('-y [value]'){|v| option[:y] = v }
opt.on('-m [value]'){|v| option[:m] = v }
opt.parse(ARGV)

year = option[:y].to_i
month = option[:m].to_i

if year == 0 
  year = today_year
end

if month == 0 
  month = today_month
end


date = Date.new(year, month, -1)
puts date.strftime("%m月 %Y").center(18)
puts "日 月 火 水 木 金 土"

days = (1..date.day)
days.each do |day|
  everyday = Date.new(year, month, day)

  if everyday.day == 1
    case everyday.cwday
    when 7
      print ""
    else
      week = (everyday.cwday)*3
      print "".to_s.ljust(week)
    end
  end

  if everyday.saturday?
    print everyday.day.to_s.ljust(3)
    print "\n"
  else
    print everyday.day.to_s.ljust(3) 
  end
end
