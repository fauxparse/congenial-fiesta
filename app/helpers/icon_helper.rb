# frozen_string_literal: true

module IconHelper
  def icon(name, options = {})
    inline_svg(
      "icons/#{name}",
      options.merge(
        class: class_string('icon', "icon-#{name}", options[:class])
      )
    )
  end
end
