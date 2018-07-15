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

    # rubocop:disable Naming/MemoizedInstanceVariableName
    def festival
      @current_festival ||=
        Festival.find_by(year: params[:year] || Time.zone.today.year)
    end
    # rubocop:enable Naming/MemoizedInstanceVariableName

    helper_method :festival
  end
end
