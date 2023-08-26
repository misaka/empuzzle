# frozen_string_literal: true

Rails.application.routes.draw do
  # resources :puzzle_sheets
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("puzzles")

  resources :puzzles,
            only: %i[create index new show],
            path_names: { new: ":puzzle_type/new" }
  resolve("Puzzles::MathsGrid") do |puzzle, options|
    [:puzzle, puzzle.id]
  end

  # namespace :puzzles do
  #   get "maths-grid", controller: :maths_grid, action: :new
  #   get "maths-grid/edit", controller: :maths_grid, action: :edit
  #   post "maths-grid", controller: :maths_grid, action: :create
  #   # get "maths-gridzilla"
  #   # get "number-line-maths"
  # end
end
