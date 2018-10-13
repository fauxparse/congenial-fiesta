# frozen_string_literal: true

class RoleBasedPolicy < ApplicationPolicy
  def index?
    authorized?
  end

  def show?
    authorized?
  end

  def create?
    authorized?
  end

  def update?
    authorized?
  end

  def destroy?
    authorized?
  end

  private

  def authorized?
    user.admin? || user.role?(self.class.const_get(:ROLE))
  end
end
