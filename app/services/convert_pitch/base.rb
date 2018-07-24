# frozen_string_literal: true

class ConvertPitch
  class Base
    attr_reader :pitch

    def initialize(pitch)
      @pitch = pitch
    end

    def call
      activities.compact
    end

    def activities
      @activities ||= create_activities
    end

    def participant
      @participant ||= pitch.participant.tap do |participant|
        participant.update!(
          bio: participant.bio || presenter_info.bio,
          city: participant.bio || presenter_info.city,
          country: participant.country || presenter_info.country
        )
      end
    end

    def workshop
      @workshop ||=
        create_unless_exists(
          Workshop,
          festival: pitch.festival,
          pitch: pitch,
          name: activity_info.name,
          description: activity_info.workshop_description,
          level_list: activity_info.levels.to_a,
          maximum: number_of_workshop_participants
        )
    end

    def show
      @show ||=
        create_unless_exists(
          Show,
          festival: pitch.festival,
          pitch: pitch,
          name: activity_info.name,
          description: activity_info.show_description,
          maximum: activity_info.cast_size
        )
    end

    def create_activities
      []
    end

    private

    def create_unless_exists(klass, attributes)
      add_presenters(klass.create!(attributes)) \
        unless pitch.activities.where(type: klass.name).exists?
    end

    def add_presenters(activity)
      activity.presenters.create!(participant: participant)
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

    def number_of_workshop_participants
      if activity_info.respond_to?(:number_of_participants)
        activity_info.number_of_participants
      else
        16
      end
    end
  end
end
