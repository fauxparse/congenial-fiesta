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

    private

    def people
      @people ||= Participant.all
    end

    def serialized_people
      PeopleSerializer.new(self: current_participant, people: people).call
    end
  end
end
