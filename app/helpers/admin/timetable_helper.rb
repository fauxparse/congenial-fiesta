# frozen_string_literal: true

module Admin
  module TimetableHelper
    def timetable
      @timetable ||= Timetable.new(festival)
    end

    def activity_name_editor
      text_area_tag(
        'schedule[activity][name]',
        '',
        rows: 1,
        autocomplete: 'off',
        placeholder: t('admin.schedules.modal.autocomplete_instructions'),
        data: activity_name_editor_data
      )
    end

    def activity_name_editor_data
      {
        target: 'admin--schedule.activityName autocomplete.input',
        action: [
          'focus->autocomplete#focus',
          'blur->autocomplete#blur',
          'input->autocomplete#textChanged'
        ].join(' ')
      }
    end

    def time_range(start, finish, format: :time)
      [start, finish]
        .map { |time| I18n.l(time, format: format) }
        .join('–')
    end
  end
end
