module RandomInRange
  def random_in_range(from, to)
    range = to - from

    if range.zero?
      to
    else
      from + @random.rand(range).round
    end
  end
end
