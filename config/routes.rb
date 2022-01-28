Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: redirect('puzzles')

  get 'puzzles', controller: :puzzles, action: :index
  namespace :puzzles do
    get 'maths-grid', controller: :maths_grid, action: :show
  end
end
