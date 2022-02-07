module RandomInRange
  def random_in_range(from, to, random:)
    range = to - from

    if range.zero?
      to
    else
      from + random.rand(range).round
    end
  end
end
