# frozen_string_literal: true

class ConvertPitch
  class StandaloneWorkshop < Base
    def create_activities
      [workshop, *super]
    end
  end
end
