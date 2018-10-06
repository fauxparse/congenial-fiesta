# frozen_string_literal: true

module Sluggable
  extend ActiveSupport::Concern

  included do
    acts_as_url :name, sluggable_options

    auto_strip_attributes :name

    validates :name, :slug, presence: true

    alias_method :to_param, :slug
  end

  module ClassMethods
    def random_deduplicator
      Enumerator.new { |enum| loop { enum.yield rand(10_000..99_999) } }
    end

    def sluggable_options
      {
        url_attribute: :slug,
        limit: 32,
        only_when_blank: true,
        duplicate_sequence: random_deduplicator,
        scope: sluggable_scope
      }
    end

    def sluggable_scope
      %i[festival_id type].select do |column|
        column_names.include?(column.to_s)
      end
    end
  end
end
