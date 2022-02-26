require 'rails_helper'

RSpec.feature "maths gridzilla puzzle" do
  def puzzles_page
    @puzzles_page ||= PuzzlesPageObject.new
  end

  def maths_gridzilla_page
    @maths_gridzilla_page ||= Puzzles::MathsGridzillaPageObject.new
  end

  scenario "default rows and columns set correctly" do
    maths_gridzilla_page.load

    expect(maths_gridzilla_page.rows_field.value).to eq "4"
    expect(maths_gridzilla_page.columns_field.value).to eq "6"

    expect(maths_gridzilla_page.rows.count).to eq 4
    expect(maths_gridzilla_page.rows[0].cells.count).to eq 6
  end
end
