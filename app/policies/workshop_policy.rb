# frozen_string_literal: true

class WorkshopPolicy < ActivityPolicy
  def show?
    super || presenting?
  end

  class Scope < ApplicationPolicy::Scope
    def initialize(user, festival)
      super(user, festival.workshops.presented_by(user))
    end
  end

  private

  def presenting?
    record.presenters.where(participant: user).exists?
  end
end
