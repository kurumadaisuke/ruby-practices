# frozen_string_literal: true

scores = ARGV[0].split(',')

shots = []
scores.each do |s|
  if s == 'X'
    shots << 10
    shots << 0
  else
    shots << s.to_i
  end
end

frames = []
shots.each_slice(2) do |s|
  s.delete(0) if s[0] == 10
  frames << s
end

# 1~9投目までの合計値
pitch_ninth = frames[0..8]
pitch_ninth.each.with_index do |frame, i|
  if frame[0] == 10 && frames[i + 1][0] == 10 # ダブル以上
    frames[i].push(frames[i + 1][0].to_i, frames[i + 2][0].to_i)
  elsif frame[0] == 10 # ストライク
    frames[i].push(frames[i + 1][0].to_i, frames[i + 1][1].to_i)
  elsif frame.sum == 10 # スペア
    frames[i].push(frames[i + 1][0].to_i)
  end
  i + 1
end

# 10投目の合計値
if frames[9].sum >= 10 && frames[10].sum >= 10
  frames[9].concat(frames[10], frames[11])
  2.times { frames.delete_at(10) }
elsif frames[9].sum >= 10
  frames[9].concat(frames[10])
  frames.delete_at(10)
end

puts frames.flatten.sum
