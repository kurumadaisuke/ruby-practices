# frozen_string_literal: true

score = ARGV[0]
scores = score.split(',')
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
  frames << s
end

point = 0
frames.each do |frame|
  if frame[0] == 10 # strikeだった場合
    point += 10
    frame.delete(0)
  elsif frame.sum == 10 # spareだった場合
    point += frame[0] + 10
  else
    point += frame.sum
  end
end

# 10投目判断
if frames[9][0] == 10 && frames[10][0] == 10 # ダブル
  last_pitching_strike_one = frames[10][0].to_i
  frames[9].push(last_pitching_strike_one)
  frames[10].clear
  last_pitching_strike_two = frames[11][0].to_i
  frames[9].push(last_pitching_strike_two)
  frames[11].clear
elsif frames[9][0] == 10 # strike
  last_pitching_strike_one = frames[10][0].to_i
  frames[9].push(last_pitching_strike_one)
  last_pitching_strike_two = frames[10][1].to_i
  frames[9].push(last_pitching_strike_two)
  frames[10].clear
elsif frames[9].sum == 10 # spare
  last_pitching_spare = frames[10][0].to_i
  frames[9].push(last_pitching_spare)
  frames[10].clear
end

# ボーナスポイント代入
frames.each.with_index do |frame, i|
  if frame[0] == 10 && frames[i + 1][1].is_a?(NilClass) && frames[i + 2].is_a?(NilClass) # ターキー
    strike_bonus_points_one = frames[i + 1][0].to_i
    frames[i].push(strike_bonus_points_one)
  elsif frame[0] == 10 && frames[i + 1][1].is_a?(NilClass) # ダブル
    strike_bonus_points_one = frames[i + 1][0].to_i
    frames[i].push(strike_bonus_points_one)
    strike_bonus_points_two = frames[i + 2][0].to_i
    frames[i].push(strike_bonus_points_two)
  elsif frame[0] == 10 # 単発strike
    strike_bonus_points_one = frames[i + 1][0].to_i
    strike_bonus_points_two = frames[i + 1][1].to_i
    frames[i].push(strike_bonus_points_one)
    frames[i].push(strike_bonus_points_two)
  elsif frame.sum == 10 # spare
    spare_bonus_points = frames[i + 1][0].to_i
    frames[i].push(spare_bonus_points)
  end
  i + 1
end
puts frames.flatten.sum
