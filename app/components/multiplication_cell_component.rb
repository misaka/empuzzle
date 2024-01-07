# frozen_string_literal: true

class MultiplicationCellComponent < ViewComponent::Base
  erb_template <<~ERB
    <%= equation.numbers.map { |factor| "<span class='factor'>\#{factor}</span>" }.join(" x ").html_safe %>
    =
    <span class="<%= @show_answers || "invisible " %>print:hidden">
      <%= equation.result %>
    </span>
  ERB

  attr_reader :equation, :show_answers

  def initialize(equation:, show_answers:)
    super

    @equation = equation
    @show_answers = show_answers
  end
end
