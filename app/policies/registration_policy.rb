# frozen_string_literal: true

class RegistrationPolicy < ApplicationPolicy
  def update?
    if user
      user.admin? || user == record.participant
    else
      !record.participant_id
    end
  end
end
