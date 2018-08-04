# frozen_string_literal: true

class Workshop < Activity
  acts_as_taggable_on :levels

  LEVELS = %i[rookie intermediate advanced].freeze

  def self.levels
    LEVELS
  end
end
