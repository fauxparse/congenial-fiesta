# frozen_string_literal: true

module Admin
  module TimetableHelper
    START_OF_DAY = 9
    END_OF_DAY = 24
    GRID_SIZE = 2

    def time_slots(day = festival.start_date)
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

    def activity_name_editor
      text_area_tag(
        'schedule[activity][name]',
        '',
        rows: 1,
        autocomplete: 'off',
        placeholder: t('admin.schedules.modal.autocomplete_instructions'),
        data: {
          target: 'admin--schedule.activityName autocomplete.input',
          action: [
            'focus->autocomplete#focus',
            'blur->autocomplete#blur',
            'input->autocomplete#textChanged'
          ].join(' ')
        }
      )
    end
  end
end
