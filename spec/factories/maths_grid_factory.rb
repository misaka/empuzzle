#!/usr/bin/env ruby

FactoryBot.define do
  factory :maths_grid, class: Puzzles::MathsGrid do
    level { "ages_6_to_7" }
  end
end
