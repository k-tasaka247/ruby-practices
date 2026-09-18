# frozen_string_literal: true

class Frame
  protected attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score(following_frames)
    cureent_frame_sum = sum
    return cureent_frame_sum unless bonus?

    next_frame = following_frames[0]
    next_shot_score = next_frame.shots[0].score

    cureent_frame_sum + if spare?
                          next_shot_score
                        elsif next_frame.second_shot?
                          next_shot_score + next_frame.shots[1].score
                        else
                          next_shot_score + following_frames[1].shots[0].score
                        end
  end

  protected

  def second_shot?
    !shots[1].nil?
  end

  private

  def strike?
    @shots[0].score == 10
  end

  def spare?
    !strike? && @shots[0..1].sum(&:score) == 10
  end

  def sum
    @shots.sum(&:score)
  end

  def bonus?
    (strike? || spare?) && @shots.size != 3
  end
end
