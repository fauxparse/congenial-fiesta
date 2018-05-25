# frozen_string_literal: true

module TextHelper
  class MarkdownRenderer < Redcarpet::Render::HTML
    include Redcarpet::Render::SmartyPants

    def link(link, title, content)
      %(<a href="#{link}" title="#{title}" class="text-link" ) +
        %(target="_blank">#{content}</a>)
    end
  end

  def markdown(text)
    markdown_renderer.render(text).html_safe
  end

  alias m markdown

  private

  def markdown_renderer
    @markdown_renderer ||=
      Redcarpet::Markdown.new(MarkdownRenderer, autolink: true)
  end
end
