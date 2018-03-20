# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :participant

  scope :password, -> { where(type: 'Identity::Password') }
end
