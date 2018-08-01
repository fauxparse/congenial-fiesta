# frozen_string_literal: true

module IconHelper
  DEFAULT_ICON_OPTIONS = {
    width: 24,
    height: 24
  }.freeze

  def inline_icon(name, options = {})
    inline_svg(
      "icons/#{name}.svg",
      options.merge(class: icon_class(name, options))
    )
  end

  def icon(name, options = {})
    options[:class] = icon_class(name, options)
    svg name, options.reverse_merge(DEFAULT_ICON_OPTIONS)
  end

  private

  def icon_class(name, options)
    class_string('icon', "icon--#{name.to_s.tr('_', '-')}", options[:class])
  end
end
