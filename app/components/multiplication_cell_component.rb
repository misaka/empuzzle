# frozen_string_literal: true

class MultiplicationCellComponent < ViewComponent::Base
  erb_template <<~ERB
    <%= equation.numbers.map { |factor| "<span class='factor'>\#{factor}</span>" }.join(" x ").html_safe %>
    =
    <span class="print:hidden"><%= equation.result %></span>
  ERB

  attr_reader :equation, :maths_grid

  def initialize(equation:)
    super

    @equation = equation
  end
end
