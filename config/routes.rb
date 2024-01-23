# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect("puzzles")

  resources :puzzles,
            only: %i[create index new show],
            path_names: {
              new: ":puzzle_type/new"
            }
  # When we nest this route in the puzzles resource, it preceds the new route
  # breaking it.
  get "puzzles/:puzzle_type/:seed", to: "puzzles#show", as: :puzzle_generator

  resolve("Puzzles::Maths::ArithmeticGrid") do |puzzle|
    route_for(:puzzle, action: :show, id: puzzle.id)
  end

  resolve("Puzzles::Maths::ArithmeticGrid::TimesTable") do |puzzle|
    route_for(:puzzle, action: :show, id: puzzle.id)
  end

  resolve("Puzzles::Maths::NumberLineArithmetic") do |puzzle|
    route_for(:puzzle, action: :show, id: puzzle.id)
  end
end
