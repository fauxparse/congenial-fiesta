# frozen_string_literal: true

module Admin
  class Controller < ::ApplicationController
    authenticate

    before_action :require_admin

    after_action :verify_authorized

    layout 'admin'

    private

    def require_admin
      render(status: :unauthorized) unless authorized_user?
    end

    def authorized_user?
      current_participant&.admin? || current_participant&.role_list&.any?
    end

    # rubocop:disable Naming/MemoizedInstanceVariableName
    def festival
      @current_festival ||=
        Festival.find_by(year: params[:year] || Time.zone.today.year)
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName

    helper_method :festival
  end
end
