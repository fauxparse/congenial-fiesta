# frozen_string_literal: true

module BadgesHelper
  def badge(count, options = {})
    options = options.merge(class: class_string('badge', options[:class]))
    content_tag(:span, count, options) unless count.blank? || count.zero?
  end
end
