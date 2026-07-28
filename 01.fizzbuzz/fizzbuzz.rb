#!/usr/bin/env ruby

count = 0

20.times do
  count += 1
  case
  when count % 3.0 == 0 && count % 5.0 == 0
    puts "FizzBuzz"
  when count % 3.0 == 0 && count % 5.0 != 0
    puts "Fizz"
  when count % 3.0 != 0 && count % 5.0 == 0
    puts "Buzz"
  else
    puts count
  end
end
