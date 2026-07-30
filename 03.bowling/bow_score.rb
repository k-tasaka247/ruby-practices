#!/usr/bin/env ruby

score = ARGV[0]
scores = score.split(',')
shots = Array.new

scores.each do |shot|
  if shot == 'X'
    shots << 10
    shots << 0
  else
    shots << shot.to_i
  end
end

frames = shots.each_slice(2).to_a
point = 0

(0..9).each do |c|
  if frames[c][0] == 10
    if frames[c+1][0] == 10
      point += 20 + frames[c+2][0]
    else
      point += 10 + frames[c+1].sum
    end
  elsif frames[c].sum == 10
    point += 10 + frames[c+1][0]
  else
    point += frames[c].sum
  end
end
puts point
