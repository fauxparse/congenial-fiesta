# frozen_string_literal: true

class Pitch
  class Info < Hashie::Dash
    include Hashie::Extensions::Dash::Coercion

    property :code_of_conduct_accepted, default: false
    property :participant,
      coerce: ParticipantInfo,
      default: -> { ParticipantInfo.new }

    def self.dump(obj)
      ActiveSupport::JSON.encode(obj.to_h)
    end

    def self.load(raw_hash)
      hash = raw_hash && ActiveSupport::JSON.decode(raw_hash) || {}
      new(hash.deep_symbolize_keys)
    end
  end
end
