require "rails_helper"

RSpec.feature "arithmetic grid journey" do
  scenario "happy path journey" do
    given_i_am_on_the_site_main_page
    when_i_click_the_new_arithmetic_grid_button
    then_i_see_the_new_arithmetic_grid_page

    when_i_set_a_reward
    and_i_click_the_generate_sheet_button
    then_the_puzzle_displays_a_2_by_8_grid
    and_i_see_the_reward
    and_the_answers_are_hidden
    when_i_click_the_show_answers_button
    then_the_answers_are_visible

    when_i_click_the_back_button
    and_i_change_the_level_to_7_to_8
    and_i_change_the_size_to_small
    and_i_click_the_generate_sheet_button
    then_the_puzzle_displays_a_2_by_6_grid

    when_i_go_back_to_the_root_page
    then_i_see_the_arithmetic_grid_puzzle_that_was_generated
    when_i_click_the_arithmetic_grid_that_was_generated
    then_i_see_the_arithmetic_grid_puzzle_that_was_generated_earlier
  end

  def given_i_am_on_the_site_main_page
    visit "/puzzles"
  end

  def when_i_click_the_new_arithmetic_grid_button
    click_button "New Arithmetic Grid"
  end

  def then_i_see_the_new_arithmetic_grid_page
    expect(page).to have_css("h1", text: "Arithmetic Grid")
  end

  def when_i_set_a_reward
    fill_in("Reward", with: "So much TV time!")
  end

  def when_i_click_the_generate_sheet_button
    click_button("Generate sheet")
  end
  alias_method :and_i_click_the_generate_sheet_button,
               :when_i_click_the_generate_sheet_button

  def then_the_puzzle_displays_a_2_by_8_grid
    expect(page).to have_css(".kids-puzzles-maths-grid-row", count: 8)
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 16)
    @generated_page_text = page.text
  end

  def and_i_see_the_reward
    expect(page).to have_text("Reward: So much TV time!")
  end

  def and_the_answers_are_hidden
    expect(page.find(".kids-puzzles-puzzle")).to have_css("span.invisible")
  end

  def when_i_click_the_show_answers_button
    click_link("Show answers")
  end

  def then_the_answers_are_visible
    expect(page).not_to have_css("span.invisible")
  end

  def when_i_click_the_back_button
    click_link("Back")
  end

  def and_i_change_the_level_to_7_to_8
    select("ages 7 to 8 (KS2)", from: "Level")
  end

  def and_i_change_the_size_to_small
    select("Small", from: "Size")
  end

  def then_the_puzzle_displays_a_2_by_6_grid
    expect(page).to have_css(".kids-puzzles-maths-grid-row", count: 6)
    expect(page).to have_css(".kids-puzzles-maths-grid-cell", count: 12)
    @generated_page_text = page.find(".kids-puzzles-puzzle").text
  end

  def when_i_go_back_to_the_root_page
    click_link("empuzzle")
  end

  def then_i_see_the_arithmetic_grid_puzzle_that_was_generated
    expect(
      page.find(
        "a",
        text: "Arithmetic Grid Puzzle for ages 7 to 8 (KS2) (Small, 2x6)"
      )
    ).to be_visible
  end

  def when_i_click_the_arithmetic_grid_that_was_generated
    first("a", text: /Arithmetic Grid Puzzle/).click
  end

  def then_i_see_the_arithmetic_grid_puzzle_that_was_generated_earlier
    expect(page.find(".kids-puzzles-puzzle").text).to eq @generated_page_text
  end
end
