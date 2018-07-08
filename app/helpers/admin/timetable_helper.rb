# frozen_string_literal: true

module Admin
  module TimetableHelper
    START_OF_DAY = 9
    END_OF_DAY = 24
    GRID_SIZE = 2

    def times(day = festival.start_date)
      return enum_for(:times, day) unless block_given?
      time = day.beginning_of_day
      (START_OF_DAY...END_OF_DAY).each do |hour|
        (0...GRID_SIZE).each do |minute|
          yield time.change(hour: hour, min: 60 * minute / GRID_SIZE)
        end
      end
    end

    def days
      return enum_for(:days) unless block_given?
      (festival.start_date..festival.end_date).each do |date|
        yield date
      end
    end
  end
end
