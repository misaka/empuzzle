# frozen_string_literal: true

class BreadcrumbsComponent < ViewComponent::Base
  def initialize(crumbs)
    super

    @crumbs = crumbs
  end
end
