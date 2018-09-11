# frozen_string_literal: true

module Admin
  class PeopleController < Controller
    def index
      authorize Participant, :index?
      respond_to do |format|
        format.json { render json: serialized_people }
        format.html
      end
    end

    def edit
      authorize person, :update?
    end

    def update
      authorize person, :update?
      if person.update(person_params)
        update_succeeded
      else
        update_failed
      end
    end

    private

    def person
      @person = Participant.find(params[:id])
    end

    helper_method :person

    def people
      @people ||=
        Participant
        .all
        .includes(:registrations)
        .sort_by { |person| person.name.upcase }
    end

    helper_method :people

    def person_params
      params
        .require(:person)
        .permit(:name, :email, :city, :country_code, :bio, :avatar, :admin)
    end

    def serialized_people
      PeopleSerializer.new(self: current_participant, people: people).call
    end

    def update_succeeded
      respond_to do |format|
        format.json { render json: PersonSerializer.new(person).call }
        format.html { redirect_to admin_people_path, notice: t('.updated') }
      end
    end

    def update_failed
      respond_to do |format|
        format.json { render json: PersonSerializer.new(person).call }
        format.html { render :edit }
      end
    end
  end
end
