# Game
- initialize(bowling_score)
- calculate_score
- build_frames
- bonus_point(frame, frame_number)

# Frame
### attr_accessor :first_shot, :second_shot

- initialize(first_mark, second_mark, third_mark, frame_number)
- score
- strike?
- spare?
- until_nine?

# Shot
- initialize(mark)
- score
