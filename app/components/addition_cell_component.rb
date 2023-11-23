# frozen_string_literal: true

class AdditionCellComponent < ViewComponent::Base
  erb_template <<~ERB
    <%= equation.numbers.join(" + ").html_safe %>
    =
    <span class="print:hidden"><%= equation.result %></span>
  ERB

  attr_reader :equation, :maths_grid

  def initialize(equation:)
    super

    @equation = equation
  end
end
