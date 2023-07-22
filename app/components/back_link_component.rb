# frozen_string_literal: true

class BackLinkComponent < ViewComponent::Base
  def initialize(text: "Back", route: :back)
    @text = text
    @route = route
  end
end
