# frozen_string_literal: true

class Pitch
  class StandaloneWorkshopInfo < WorkshopInfo
    validates :workshop_description, presence: true
  end
end
