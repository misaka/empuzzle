# frozen_string_literal: true

Rails.application.routes.draw do
  root to: redirect("puzzles")

  resources :puzzles,
            only: %i[create index new show],
            path_names: { new: ":puzzle_type/new" }
  resolve("Puzzles::MathsGrid") do |puzzle, options|
    [:puzzle]
  end
end
