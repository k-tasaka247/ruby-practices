#!/usr/bin/env ruby

score = ARGV[0]
p scores = score.split(',')
shots = Array.new

scores.each do |shot|
  if shot == 'X'
    shots << 10
    shots << 0
  else
    shots << shot.to_i
  end
end
p shots

frames = shots.each_slice(2).to_a
p frames

point = frames.sum do |frame|
  if frame[0] == 10
    30
  elsif frame.sum == 10
    frame[0] + 10
  else
    frame.sum
  end
end
puts point