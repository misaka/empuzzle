require "rails_helper"

RSpec.feature "sessions" do
  scenario "accessing other puzzles" do
    given_i_have_a_new_session
    when_i_go_to_the_site_main_page
    then_i_see_no_puzzles

    when_i_create_a_new_puzzle
    and_go_back_to_the_root_page
    then_i_see_my_one_puzzle

    given_i_have_a_new_session
    when_i_go_to_the_site_main_page
    then_i_see_no_puzzles

    when_i_create_a_new_puzzle
    and_go_back_to_the_root_page
    then_i_see_my_one_puzzle

    when_i_try_to_access_the_first_puzzle
    then_i_get_an_authorisation_error
  end

  def given_i_have_a_new_session
    Capybara.reset_session!
  end

  def when_i_go_to_the_site_main_page
    visit "/puzzles"
  end

  def then_i_see_no_puzzles
    expect(page).not_to have_css("a", text: /Arithmetic Grid Puzzle/)
  end

  def when_i_create_a_new_puzzle
    click_button "New Arithmetic Grid"
    click_button "Generate sheet"
    @last_puzzle_path = @puzzle_path
    @puzzle_path = page.current_path
  end

  def and_go_back_to_the_root_page
    click_link "empuzzle"
  end

  def then_i_see_my_one_puzzle
    expect(page.all("a", text: /Arithmetic Grid Puzzle/).count).to eq 1
    expect(
      page.first("a", text: /Arithmetic Grid Puzzle/).native["href"]
    ).to eq(@puzzle_path)
  end

  def when_i_try_to_access_the_first_puzzle
    visit @last_puzzle_path
  rescue StandardError => e
    @last_exception = e
  end

  def then_i_get_an_authorisation_error
    expect(@last_exception).to be_a(ActiveRecord::RecordNotFound)
  end
end
