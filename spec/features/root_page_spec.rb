# frozen_string_literal: true

require "rails_helper"

RSpec.feature "root page" do
  def root_page
    RootPageObject.new
  end

  def puzzles_page
    PuzzlesPageObject.new
  end

  scenario "visiting the root page" do
    root_page.load

    expect(puzzles_page).to be_displayed
  end
end
