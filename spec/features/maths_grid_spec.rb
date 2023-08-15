# frozen_string_literal: true

require "rails_helper"

RSpec.feature "maths grid puzzle", type: :feature do
  before do
    visit "/puzzles"
    click_link "Maths Grid"
  end

  scenario "getting to it from the puzzles page" do
    expect(page).to have_text "Maths Grid Setup"
  end

  scenario "default rows and columns set correctly" do
    expect(page.find("#puzzles_maths_grid_rows").value).to eq "4"
    expect(page.find("#puzzles_maths_grid_columns").value).to eq "6"

    expect(page).to have_css(".kids-puzzles-maths-grid-row", count: 4)
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 24)
  end

  scenario "changing number of rows and columns" do
    page.find("#puzzles_maths_grid_rows").set "5"
    page.find("#puzzles_maths_grid_columns").set "7"
    page.click_button "Generate new puzzle"

    expect(page).to have_css(".kids-puzzles-maths-grid-row", count: 5)
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 35)
  end
end
