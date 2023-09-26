# Game
- initialize(marks)
- calculate_score
- calculate_bonus_point(frame, frame_number)

# Frame
## attr_accessor :first_shot, :second_shot

- initialize(frame_number:, first_mark:, second_mark: nil, third_mark: nil)
- score
- strike?
- spare?
- until_nine?

# Shot
- initialize(mark)
- score
