# frozen_string_literal: true

class AdditionCellComponent < ViewComponent::Base
  attr_reader :equation

  def initialize(equation:)
    super

    @equation = equation
  end
end
