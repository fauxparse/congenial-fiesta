# frozen_string_literal: true

class PitchForm
  class Step
    include ActiveModel::Validations

    attr_reader :pitch
    attr_accessor :next, :previous

    delegate :info, to: :pitch

    def self.factory(pitch)
      new(pitch)
    end

    def initialize(pitch)
      @pitch = pitch
    end

    def attributes=(attributes)
      attributes.each do |key, value|
        send :"#{key}=", value
      end
    end

    def title
      I18n.t(:title, scope: i18n_scope)
    end

    def apply!
      pitch.save!
    end

    def first?
      previous.blank?
    end

    def last?
      self.next.blank?
    end

    def participant
      pitch.participant || pitch.build_participant
    end

    def i18n_scope
      [:pitches, :step, to_sym].join('.')
    end

    def to_sym
      self.class.name.demodulize.underscore.to_sym
    end

    def to_param
      to_sym
    end

    def to_partial_path
      "pitches/step/#{to_sym}"
    end

    def to_model
      pitch
    end
  end
end
