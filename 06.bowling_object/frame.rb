# frozen_string_literal: true

class Frame
  protected attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def frame_score(following_frames)
    return marks_sum unless bonus?

    next_frame = following_frames[0]
    return marks_sum + next_frame.shots[0].score if spare?

    marks_sum + next_frame.shots[0].score + (next_frame.shots[1] || following_frames[1].shots[0]).score
  end

  private

  def strike?
    @shots[0].strike?
  end

  def spare?
    !strike? && @shots[0..1].sum(&:score) == 10
  end

  def marks_sum
    @shots.sum(&:score)
  end

  def bonus?
    (strike? || spare?) && @shots.size != 3
  end
end
