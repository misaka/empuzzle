require 'rails_helper'

RSpec.feature "maths grid puzzle" do
  def root_page
    RootPageObject.new
  end

  def puzzles_page
    PuzzlesPageObject.new
  end

  def maths_grid_page
    Puzzles::MathsGridPageObject.new
  end

  scenario "visiting maths grid page" do
    root_page.load

    expect(puzzles_page).to be_displayed

    click_link "Maths Grid"

    expect(maths_grid_page).to be_displayed
    expect(page).to have_text "Maths Grid Setup"
  end
end
