# frozen_string_literal: true

module FaqHelper
  def question(question, &block)
    content_tag :section, class: 'faq__qa' do
      concat content_tag(:h2, question, class: 'faq__question')
      concat content_tag(:div, class: 'faq__answer', &block)
    end
  end
end
