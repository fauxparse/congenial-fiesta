# frozen_string_literal: true

module LinkHelper
  def linked_block_if(condition, options = {}, html_options = {}, &block)
    content = capture(&block) if block_given?
    link_to_if condition, content, options, html_options do
      content_tag :span, content, html_options
    end
  end
end
