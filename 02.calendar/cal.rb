#!/usr/bin/env ruby
require "optparse"
require "date"

# Make Hash for Month and Year
options = { y: Date.today.year, m: Date.today.mon }

# Option Variable
opt = OptionParser.new

# Set Options for `-m` and `-y`
opt.on("-m MON", Integer){ |v| options[:m] = v }
opt.on("-y YEAR", Integer){ |v| options[:y] = v }
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
(first_date..last_date).each do |date| 
  day = date.day.to_s.rjust(2)
  if date.wday == 6
    puts day
  else
    print day + " "
  end
end

# Line Break
Standard_Week_Number = 5
print first_date.wday + last_date.day < (7 * Standard_Week_Number) ? "\n\n" : "\n"
