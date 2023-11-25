# frozen_string_literal: true

class DivisionCellComponent < ViewComponent::Base
  erb_template <<~ERB
    <%= equation.numbers.first %> ÷ <%= equation.numbers.last %>
    =
    <span class="print:hidden"><%= equation.result %></span>
  ERB

  attr_reader :equation

  def initialize(equation:)
    super

    @equation = equation
  end
end
