# frozen_string_literal: true

class SubtractionCellComponent < ViewComponent::Base
  erb_template <<~ERB
    <%= equation.numbers.map { |n| "<span class='kids-puzzles-number'>\#{n}</span>" }.join(" - ").html_safe %>
    =
    <span class="print:hidden"><%= equation.result %></span>
  ERB

  attr_reader :equation

  def initialize(equation:)
    super

    @equation = equation
  end
end
