# frozen_string_literal: true

module IconHelper
  def icon(name, options = {})
    inline_svg(
      "icons/#{name}.svg",
      options.merge(class: icon_class(name, options))
    )
  end

  private

  def icon_class(name, options)
    class_string('icon', "icon-#{name.to_s.tr('_', '-')}", options[:class])
  end
end
