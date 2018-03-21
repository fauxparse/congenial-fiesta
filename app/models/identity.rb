# frozen_string_literal: true

class Identity < ApplicationRecord
  belongs_to :participant

  enum provider:
    OmniAuth.registered_providers.map { |p| [p, p.to_s] }.to_h.freeze

  scope :password, -> { where(type: 'Identity::Password') }
end
