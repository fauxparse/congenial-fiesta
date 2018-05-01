# frozen_string_literal: true

class Festival < ApplicationRecord
  validates :year, presence: true, uniqueness: true
  validates :start_date, :end_date, presence: true
  validates :end_date,
    date: { on_or_after: :start_date },
    if: %i[start_date end_date]

  def to_param
    year.to_s
  end

  def to_s
    "#{I18n.t('festival.name.short')} #{year}"
  end
end
