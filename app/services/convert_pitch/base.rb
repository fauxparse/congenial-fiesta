# frozen_string_literal: true

class ConvertPitch
  class Base
    attr_reader :pitch

    def initialize(pitch)
      @pitch = pitch
    end

    def call
      activities
    end

    def activities
      @activities ||= create_activities.map(&method(:add_presenters))
    end

    def participant
      @participant ||= pitch.participant.tap do |participant|
        participant.update!(
          {}
        )
      end
    end

    def workshop
      @workshop ||=
        Workshop.create!(
          festival: pitch.festival,
          pitch: pitch,
          name: activity_info.name,
          description: activity_info.workshop_description
        )
    end

    def show
      @show ||=
        Show.create!(
          festival: pitch.festival,
          pitch: pitch,
          name: activity_info.name,
          description: activity_info.show_description
        )
    end

    def create_activities
      []
    end

    private

    def add_presenters(activity)
      activity.presenters.create!(
        participant: participant,
        bio: presenter_info.bio,
        city: presenter_info.city,
        country: presenter_info.country
      )
      activity
    end

    def info
      pitch.info
    end

    def presenter_info
      info.presenter
    end

    def activity_info
      info.activity
    end
  end
end
