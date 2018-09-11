# frozen_string_literal: true

class Dashboard
  class Widget
    attr_reader :festival

    def initialize(festival)
      @festival = festival
    end

    def to_partial_path
      self.class.name.underscore
    end
  end
end
