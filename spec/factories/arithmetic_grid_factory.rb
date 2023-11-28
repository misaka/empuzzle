#!/usr/bin/env ruby

FactoryBot.define do
  factory :arithmetic_grid, class: Puzzles::Maths::ArithmeticGrid do
    level { "ages_6_to_7" }
  end
end
