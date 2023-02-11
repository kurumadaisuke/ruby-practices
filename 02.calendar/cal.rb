require 'date'
require 'optparse'

opt = OptionParser.new
option = {}
opt.on('-y [value]'){|v| option[:y] = v }
opt.on('-m [value]'){|v| option[:m] = v }
opt.parse(ARGV)

year = option[:y].to_i == 0 ? Date.today.year : option[:y].to_i
month = option[:m].to_i == 0 ? Date.today.month : option[:m].to_i

end_of_month = Date.new(year, month, -1)
puts end_of_month.strftime("%m月 %Y").center(18)
puts "日 月 火 水 木 金 土"

days = (1..end_of_month.day)
days.each do |day|
  each_day = Date.new(year, month, day)

  if each_day.day == 1
    case each_day.cwday
    when 7
      print ""
    else
      week = (each_day.cwday)*3
      print "".to_s.ljust(week)
    end
  end

  if each_day.saturday?
    print each_day.day.to_s.ljust(3)
    print "\n"
  else
    print each_day.day.to_s.ljust(3) 
  end
end
