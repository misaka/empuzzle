# frozen_string_literal: true

module RandomInRange
  def random_in_range(from, to, random:)
    range = to - from

    if range.zero?
      to
    else
      from + random.rand(range + 1).round
    end
  end
end
