# frozen_string_literal: true

class Workshop < Activity
  acts_as_taggable_on :levels
end
