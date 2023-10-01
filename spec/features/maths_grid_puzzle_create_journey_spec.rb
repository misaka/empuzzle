require "rails_helper"

RSpec.feature "maths grid journey" do
  scenario "happy path journey" do
    given_i_am_on_the_site_main_page
    when_i_click_the_new_maths_grid_button
    then_i_see_the_new_maths_grid_page

    when_i_change_the_level_to_7_to_8
    then_the_puzzle_updates_to_10_rows

    when_i_click_back_to_puzzles_list
    then_i_see_the_maths_grid_puzzle_that_was_generated
  end

  def given_i_am_on_the_site_main_page
    visit "/puzzles"
  end

  def when_i_click_the_new_maths_grid_button
    click_button "New Maths Grid"
  end

  def then_i_see_the_new_maths_grid_page
    expect(page).to have_css("h1", text: "Maths Grid")
  end

  def when_i_change_the_level_to_7_to_8
    select("ages 7-8 (KS2)", from: "Level")
    click_button("Generate sheet")
  end

  def then_the_puzzle_updates_to_10_rows
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 12)
  end

  def when_i_click_print_page
    click_button("Print page")
  end

  def when_i_click_back_to_puzzles_list
    click_link("Back to puzzles list")
  end

  def then_i_see_the_maths_grid_puzzle_that_was_generated
    expect(page).to have_text("Maths Grid")
  end
end
