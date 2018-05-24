# frozen_string_literal: true

class Pitch
  class Info < Hashie::Dash
    include Hashie::Extensions::Dash::Coercion

    property :code_of_conduct_accepted, default: false
    property :presenter,
      default: -> { PresenterInfo.new },
      coerce: PresenterInfo
    property :activity,
      default: -> { StandaloneWorkshopInfo.new },
      coerce: ->(v) { Pitch.const_get("#{v[:type]}_info".camelize).new(v) }

    def self.dump(obj)
      obj.to_h
    end

    def self.load(raw_hash)
      new((raw_hash || {}).deep_symbolize_keys)
    end
  end
end
