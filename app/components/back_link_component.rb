# frozen_string_literal: true

class BackLinkComponent < ViewComponent::Base
  def initialize(route: :back, text:)
    super

    @text = text
    @route = route
  end
end
