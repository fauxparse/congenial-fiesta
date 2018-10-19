# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :participant
  belongs_to :subject, polymorphic: true

  validates :text, presence: true
end
