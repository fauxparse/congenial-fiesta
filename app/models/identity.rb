# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :participant

  enum provider: {
    google: 'google',
    facebook: 'facebook',
    twitter: 'twitter'
  }

  scope :password, -> { where(type: 'Identity::Password') }
end
