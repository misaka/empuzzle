#!/usr/bin/env ruby

FactoryBot.define do
  factory :maths_grid, class: Puzzles::MathsGrid do
    level { "ages 6-7 (KS1)" }
  end
end