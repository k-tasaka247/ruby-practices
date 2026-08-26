#!/usr/bin/env ruby

(1..20).each do |c|
  case
  when c % 3 == 0 && c % 5 == 0
    puts "FizzBuzz"
  when c % 3 == 0
    puts "Fizz"
  when c % 5 == 0
    puts "Buzz"
  else
    puts c
  end
end
