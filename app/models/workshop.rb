# frozen_string_literal: true

class Workshop < Activity
  acts_as_taggable_on :levels

  LEVELS = %i[rookie intermediate advanced].freeze

  def sorted_level_list
    level_list.sort_by { |level| LEVELS.find_index(level) }
  end

  def self.levels
    LEVELS
  end
end
