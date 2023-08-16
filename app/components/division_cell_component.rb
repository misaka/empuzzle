# frozen_string_literal: true

class DivisionCellComponent < ViewComponent::Base
  attr_reader :equation

  def initialize(equation:)
    super

    @equation = equation
  end
end
