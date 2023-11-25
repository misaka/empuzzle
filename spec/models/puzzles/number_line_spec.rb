require "rails_helper"

RSpec.describe Puzzles::NumberLine do
  subject(:puzzle) { described_class.new }

  it "generates a puzzle" do
    expect(subject).to be_a Puzzles::NumberLine
  end

  it "generates equations" do
    expect(subject.data["cells"].length).to be 6
  end

  it "generates equations with keys numbers, result and type" do
    expect(subject.data["cells"].first).to(
      include(
        "numbers" => [a_kind_of(Integer), a_kind_of(Integer)],
        "result" => a_kind_of(Integer),
        "type" => a_kind_of(String)
      )
    )
  end
end
