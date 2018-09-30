# frozen_string_literal: true

class Festival < ApplicationRecord
  has_many :pitches
  has_many :activities
  has_many :schedules, through: :activities
  has_many :registrations, dependent: :destroy
  has_many :payments, through: :registrations
  has_many :selections, through: :registrations
  has_many :workshops

  validates :year, presence: true, uniqueness: true
  validates :start_date, :end_date, presence: true
  validates :end_date,
    date: { on_or_after: :start_date },
    if: %i[start_date end_date]

  validates :earlybird_cutoff,
    time: { at_or_after: :registrations_open_at },
    if: %i[registrations_open_at earlybird_cutoff]

  def pitches_open?
    pitches_open_at&.past? && !pitches_close_at&.past?
  end

  def to_param
    year&.to_s
  end

  def to_s
    "#{I18n.t('festival.name.short')} #{year}"
  end

  def self.current
    order(start_date: :desc).first
  end
end
