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

    def update
      person = Participant.find(params[:id])
      authorize person, :update?
      person.update!(person_params)
      respond_to do |format|
        format.json { render json: PersonSerializer.new(person).call }
      end
    end

    private

    def people
      @people ||= Participant.all
    end

    def person_params
      params
        .require(:person)
        .permit(:name, :email, :city, :country_code, :bio, :admin)
    end

    def serialized_people
      PeopleSerializer.new(self: current_participant, people: people).call
    end
  end
end
