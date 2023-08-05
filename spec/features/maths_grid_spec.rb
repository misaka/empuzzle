# frozen_string_literal: true

require "rails_helper"

RSpec.feature "maths grid puzzle" do
  def puzzles_page
    @puzzles_page ||= PuzzlesPageObject.new
  end

  def maths_grid_page
    @maths_grid_page ||= Puzzles::MathsGridPageObject.new
  end

  scenario "getting to it from the puzzles page" do
    puzzles_page.load

    click_link "Maths Grid"

    expect(maths_grid_page).to be_displayed
    expect(page).to have_text "Maths Grid Setup"
  end

  scenario "default rows and columns set correctly" do
    maths_grid_page.load

    expect(maths_grid_page.rows_field.value).to eq "4"
    expect(maths_grid_page.columns_field.value).to eq "6"

    expect(maths_grid_page.rows.count).to eq 4
    expect(maths_grid_page.rows[0].cells.count).to eq 6
  end

  scenario "changing number of rows and columns" do
    maths_grid_page.load

    maths_grid_page.rows_field.set "5"

    expect(maths_grid_page.rows_field.value).to eq "5"
    expect(maths_grid_page.columns_field.value).to eq "6"

    expect(maths_grid_page.rows.count).to eq 4
    expect(maths_grid_page.rows[0].cells.count).to eq 6
  end
end
