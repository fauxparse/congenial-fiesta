# frozen_string_literal: true

module ApplicationHelper
  def page_title
    content_tag :title do
      if content_for?(:title)
        [content_for(:title), t('festival.name.short')]
          .reject(&:blank?)
          .join(' ⋮ ')
      else
        t('.title', default: t('festival.name.short'))
      end
    end
  end
end
