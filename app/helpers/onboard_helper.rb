# frozen_string_literal: true

module OnboardHelper
  def onboard_step(options = {}, &block)
    data = options[:data] || {}

    content_tag(
      :section,
      options.deep_merge(
        class: class_string('onboard__step', options[:class]),
        data: {
          target: class_string('onboard.step', data[:target])
        }
      ),
      &block
    )
  end
end
