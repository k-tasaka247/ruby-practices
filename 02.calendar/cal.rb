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
  print day = date.day.to_s.rjust(2)
  if date.saturday?
    print "\n"
  else
    print " "
  end
end

# Line Break
MAX_WEEK_NUMBER = 5
print "\n" if first_date.wday + last_date.day < (7 * MAX_WEEK_NUMBER)
print "\n"
