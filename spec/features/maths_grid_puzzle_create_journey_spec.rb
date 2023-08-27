require "rails_helper"

RSpec.feature "maths grid journey" do
  scenario "happy path journey" do
    given_i_am_on_the_site_main_page
    when_i_click_the_new_maths_grid_button
    then_i_see_the_new_maths_grid_page

    when_i_change_the_rows_to_10_and_submit
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
    expect(page).to have_css("h1", text: "New Maths Grid Puzzle Setup")
  end

  def when_i_change_the_rows_to_10_and_submit
    fill_in("Columns", with: "7")
    fill_in("Rows", with: "6")
    click_button("Generate new puzzle")
  end

  def then_the_puzzle_updates_to_10_rows
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 42)
  end

  def when_i_click_print_page
    click_button("Print page")
  end

  def when_i_click_back_to_puzzles_list
    click_link("Back to puzzles list")
  end

  def then_i_see_the_maths_grid_puzzle_that_was_generated
    expect(page).to have_text("Maths Grid Puzzle for ages 6-8 (7x6)")
  end
end
