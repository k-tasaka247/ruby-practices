#!/usr/bin/env ruby
require "optparse"
require "date"

# Make Hash for Month and Year
options={y: Date.today.year, m: Date.today.mon}

# Option Variable
opt = OptionParser.new

# Set Options for `-m` and `-y`
opt.on("-m MON", Integer){|v| options[:m] = v}
opt.on("-y YEAR", Integer){|v| options[:y] = v}
opt.parse!(ARGV)

# Print Month, Year, Week Day
puts "#{options[:m]}月 #{options[:y]}".center(20)
puts "日 月 火 水 木 金 土"

# Get How Many Days There Are
first_date = Date.new(options[:y], options[:m], 1)
last_date = Date.new(options[:y], options[:m], -1)

# Insert Head Space
print "   " * first_date.wday

# Print Days
(first_date..last_date).each do |day| 
  case day.wday
  when 0
    print day.day.to_s.rjust(2)+" "
  when 6
    puts day.day.to_s.rjust(2)
  else
    print day.day.to_s.rjust(2)+" "
  end
end

# Line Break
print "\n" if last_date.wday !=6
print "\n" if last_date.day == 28 && last_date.wday == 6
if last_date.day == 31 && first_date.wday >= 5
  return
elsif last_date.day == 30 && first_date.wday == 6
  return
else
  print "\n"
end
#p "\n3" unless (last_date.day == 31 && last_date.wday >= 5) || (last_date.day == 30 && last_date.wday == 6)
