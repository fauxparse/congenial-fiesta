# frozen_string_literal: true

module StimulusHelper
  def target(controller, target, tag: :div, **options, &block)
    css_class = class_string("#{controller}__#{target}", options[:class])
    target =
      class_string("#{controller}.#{target}", options.dig(:data, :target))
    options = options.deep_merge(class: css_class, data: { target: target })
    content = capture(&block) if block_given?
    content_tag tag, content, options
  end

  def copy_to_clipboard(content, icon: :copy, **options, &block)
    css_class = class_string('clipboard', options[:class])
    controller = class_string('clipboard', options.dig(:data, :controller))
    opts =
      options.deep_merge(class: css_class, data: { controller: controller })
    content_tag(:div, opts) do
      concat content_tag(:div, class: 'clipboard__content', &block)
      concat clipboard_copy_button(content, icon_name: icon)
    end
  end

  private

  def clipboard_copy_button(content, icon_name:)
    content_tag :button, class: 'clipboard__copy',
      data: { target: 'clipboard.copyButton', 'clipboard-text': content } do
      concat icon(icon_name)
    end
  end
end
