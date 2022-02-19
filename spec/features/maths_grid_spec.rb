require 'rails_helper'

RSpec.feature "maths grid puzzle" do
  scenario "visiting maths grid page" do
    visit "/"

    click_link "Maths Grid"

    expect(page).to have_text "Maths Grid Setup"
  end
end
