# frozen_string_literal: true

class WorkshopPolicy < ActivityPolicy
  def show?
    super || presenting?
  end

  private

  def presenting?
    record.presenters.where(participant: user).exists?
  end
end
