class BackButtonComponent < ViewComponent::Base
  erb_template <<~ERB
    <nav class="max-w-screen-lg container print:hidden mx-auto mt-4 px-5" aria-label="Breadcrumb">
      <div class="before:content-['<']">
        <%= link_to @text, @path, class: "underline" %>
      </div>
    </nav>
  ERB

  def initialize(text:, path:)
    super

    @text = text
    @path = path
  end
end
