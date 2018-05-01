# frozen_string_literal: true

module Admin
  class Controller < ::ApplicationController
    authenticate

    before_action :require_admin

    layout 'admin'

    private

    def require_admin
      render(status: :unauthorized) unless current_participant&.admin?
    end
  end
end
