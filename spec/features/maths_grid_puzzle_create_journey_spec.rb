require "rails_helper"

RSpec.feature "maths grid journey" do
  scenario "happy path journey" do
    given_i_am_on_the_site_main_page
    when_i_click_the_new_maths_grid_button
    then_i_see_the_new_maths_grid_page

    when_i_change_the_level_to_7_to_8
    and_i_set_a_reward
    and_i_click_the_generate_sheet_button
    then_the_puzzle_updates_to_10_rows
    and_i_see_the_reward
    and_the_answers_are_hidden
    when_i_click_the_show_answers_button
    then_the_answers_are_visible

    when_i_click_the_home_link
    then_i_see_the_maths_grid_puzzle_that_was_generated
    when_i_click_the_maths_grid_that_was_generated
    then_i_see_the_maths_grid_puzzle_that_was_generated_earlier
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
    select("ages 7 to 8 (KS2)", from: "Level")
  end

  def and_i_set_a_reward
    fill_in("Reward", with: "So much TV time!")
  end

  def and_i_click_the_generate_sheet_button
    click_button("Generate sheet")
  end

  def then_the_puzzle_updates_to_10_rows
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 20)
    @generated_page_text = page.text
  end

  def and_i_see_the_reward
    expect(page).to have_text("Reward: So much TV time!")
  end

  def and_the_answers_are_hidden
    expect(page).to have_css("span.invisible", count: 20)
  end

  def when_i_click_the_show_answers_button
    click_link("Show answers")
  end

  def then_the_answers_are_visible
    expect(page).not_to have_css("span.invisible", count: 20)
  end

  def when_i_click_the_home_link
    click_link("Home")
  end

  def then_i_see_the_maths_grid_puzzle_that_was_generated
    expect(page).to have_text("Maths Grid")
  end

  def when_i_click_the_maths_grid_that_was_generated
    first("a", text: /Maths Grid Puzzle/).click
  end

  def then_i_see_the_maths_grid_puzzle_that_was_generated_earlier
    expect(page.text).to eq @generated_page_text
  end
end
