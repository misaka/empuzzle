require "rails_helper"

RSpec.feature "number line journey" do
  scenario "happy path journey" do
    given_i_am_on_the_site_main_page
    when_i_click_the_new_number_line_button
    then_i_see_the_new_number_line_page
    and_the_level_is_set_to_6_to_7

    when_i_change_the_level_to_7_to_8
    and_i_set_a_reward
    and_i_click_the_generate_sheet_button
    then_the_puzzle_updates_to_10_rows
    and_i_see_the_reward

    when_i_click_the_home_link
    then_i_see_the_number_line_puzzle_that_was_generated
  end

  def given_i_am_on_the_site_main_page
    visit "/puzzles"
  end

  def when_i_click_the_new_number_line_button
    click_button "New Number Line"
  end

  def then_i_see_the_new_number_line_page
    expect(page).to have_css("h1", text: "Numter Line")
  end

  def and_the_level_is_set_to_6_to_7
    expect(page).to have_select("Level", selected: "ages 6 to 7 (KS1)")
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
    expect(page).to have_css(".kids-puzzles-number-line-cell", count: 12)
  end

  def and_i_see_the_reward
    expect(page).to have_text("Reward: So much TV time!")
  end

  def when_i_click_the_home_link
    click_link("Home")
  end

  def then_i_see_the_number_line_puzzle_that_was_generated
    expect(page).to have_text("Number Line")
  end
end
