# frozen_string_literal: true

module Hashable
  extend ActiveSupport::Concern

  def to_param
    id && self.class.hashids.encode(id)
  end

  class_methods do
    def find(*args)
      super(*unhashed_ids_for_find(*args))
    end

    def unhashed_ids_for_find(*ids)
      if ids.size > 1
        unhash_ids(ids)
      elsif ids.first.is_a?(Array)
        [unhash_ids(ids.first)]
      else
        unhash_id(ids.first)
      end
    end

    def unhash_ids(ids)
      ids.map { |id| unhash_id(id) }
    end

    def unhash_id(id)
      case id
      when Numeric then id
      else hashids.decode(id)
      end
    end

    def hashids
      @hashids ||= Hashids.new(name, 5)
    end
  end
end
