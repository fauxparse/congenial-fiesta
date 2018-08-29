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
end
