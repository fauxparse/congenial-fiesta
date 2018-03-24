# frozen_string_literal: true

module IconHelper
  def icon(name, options = {})
    inline_svg(
      "icons/#{name}",
      options.reverse_merge(class: "icon icon-#{name}")
    )
  end
end
