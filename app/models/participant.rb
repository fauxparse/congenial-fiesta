# frozen_string_literal: true

class Participant < ApplicationRecord
  auto_strip_attributes :name, :email

  has_many :identities

  validates :name, presence: true
  validates :email, uniqueness: { case_sensitive: false }, email: true
end
