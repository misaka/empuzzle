# frozen_string_literal: true

require "rails_helper"

RSpec.describe BackLinkComponent, type: :component do
  let(:component) { described_class.new(text: "space", route: "/") }
  let!(:rendered) { render_inline(component) }

  subject { page }

  it { should have_link("Back", href: "/") }
end
