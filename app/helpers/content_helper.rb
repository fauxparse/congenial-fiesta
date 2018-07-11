# frozen_string_literal: true

module ContentHelper
  def prepend_content_for(name, content = nil, &block)
    if content_for?(name)
      existing_content = content_for(name)
      content = capture(&block) if block_given?
      content_for(name, content, flush: true)
      content_for(name, existing_content)
    else
      content_for(name, content, &block)
    end
  end
end
