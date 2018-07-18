# frozen_string_literal: true

class Timetable
  START_OF_DAY = 9
  END_OF_DAY = 24
  GRID_SIZE = 2

  attr_reader :festival, :start_hour, :end_hour, :grid_size

  def initialize(festival, start_hour: START_OF_DAY, end_hour: END_OF_DAY,
    grid_size: GRID_SIZE)
    @festival = festival
    @start_hour = start_hour
    @end_hour = end_hour
    @grid_size = grid_size
  end

  def time_slots(day)
    return enum_for(:time_slots, day) unless block_given?
    times(day).each_cons(2) do |start_time, end_time|
      yield [start_time, end_time]
    end
  end

  def times(day)
    time = day.beginning_of_day
    [
      *(START_OF_DAY...END_OF_DAY).to_a.product((0...GRID_SIZE).to_a),
      [END_OF_DAY, 0]
    ].map do |hour, minute|
      time.change(hour: hour, min: minute * 60 / GRID_SIZE)
    end
  end

  def days
    return enum_for(:days) unless block_given?
    (festival.start_date..festival.end_date).each do |date|
      yield date
    end
  end
end
