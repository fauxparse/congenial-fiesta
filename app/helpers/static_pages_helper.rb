# frozen_string_literal: true

module StaticPagesHelper
  def last_updated(date)
    content_tag :div, class: 'last-updated' do
      t('pages.last_updated', date: l(date.to_date, format: :long)).html_safe
    end
  end
end
