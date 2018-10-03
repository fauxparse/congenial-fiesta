# frozen_string_literal: true

module Admin
  class RegistrationsController < Controller
    def index
      authorize festival
      respond_to do |format|
        format.json do
          render json: RegistrationSummarySerializer.new(festival).call
        end
      end
    end

    def show
      authorize registration
    end

    def update
      authorize registration, :update?
      registration_form.update(registration_params)
      redirect_to admin_person_registration_path(festival, person),
        notice: t('.updated')
    end

    private

    def person
      @person ||= Participant.find_by_hashid(params[:person_id])
    end

    def registration
      @registration ||=
        festival
        .registrations
        .includes(:participant, :festival, selections: { schedule: :activity })
        .where(participant_id: person.id)
        .first
    end

    helper_method :registration

    def registration_params
      params
        .require(:registration)
        .permit(activities: {})
    end

    def registration_form
      @registration_form ||= Admin::RegistrationForm.new(registration)
    end

    helper_method :registration_form
  end
end
