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

    def festival
      @festival ||=
        Festival.find_by!(year: params[:year] || Time.zone.today.year)
    end

    helper_method :festival
  end
end
