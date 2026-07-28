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

# 
first_date = Date.new(options[:y], options[:m], 1)
last_date = Date.new(options[:y], options[:m], -1)
list = Hash.new

if options[:m] <10
  puts "      #{options[:m]}月 #{options[:y]}"
else
  puts "     #{options[:m]}月 #{options[:y]}"
end
puts "日 月 火 水 木 金 土"

((first_date.day)..(last_date.day)).each do |day| 
  day_key = (first_date-1+day).day
  list[day_key.to_s.to_sym]=(first_date-1+day).cwday
end

case list[:"1"]
when 1
  print "   "
when 2
  print "      "
when 3
  print "         "
when 4
  print "            "
when 5
  print "               "
when 6
  print "                  "
when 7
  print ""
end

list.each do |day_key, cwday|
  day_key_s = day_key.to_s
  if day_key_s.to_i < 10
    if cwday == 6
    puts " "+day_key_s+" "
    else
    print " "+day_key_s+" "
    end
  else
    if cwday == 6
    puts day_key_s+" "
    else
    print day_key_s+" "
    end
  end
end

puts "\n"
