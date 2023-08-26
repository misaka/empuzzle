# frozen_string_literal: true

class BackLinkComponent < ViewComponent::Base
  def initialize(text:, route: :back)
    super

    @text = text
    @route = route
  end
end
