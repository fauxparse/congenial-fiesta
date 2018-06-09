# frozen_string_literal: true

class Pitch
  class FullDayWorkshopInfo < WorkshopInfo
    validates :workshop_description, presence: true
  end
end
