# frozen_string_literal: true

module MoneyHelper
  def money(amount, html_options = {}, options = {})
    format_options = options.reverse_merge(
      with_currency: true,
      sign_before_symbol: true,
      html: true
    )
    content_tag(
      :span,
      amount.format(format_options).html_safe,
      html_options.merge(class: class_string('money', html_options[:class]))
    )
  end
end
