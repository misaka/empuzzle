# frozen_string_literal: true

Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect("puzzles")

  get "puzzles", controller: :puzzles, action: :index
  namespace :puzzles do
    get "maths-gridzilla"
    get "maths-grid"
    get "number-line-maths"
  end
end
