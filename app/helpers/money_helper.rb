# frozen_string_literal: true

module MoneyHelper
  def money(amount, html_options = {}, options = {})
    content_tag(
      :span,
      amount.format(options.merge(with_currency: true, html: true)).html_safe,
      html_options.merge(class: class_string('money', html_options[:class]))
    )
  end
end
