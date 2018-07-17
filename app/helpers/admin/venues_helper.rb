# frozen_string_literal: true

module Admin
  module VenuesHelper
    def venue_name_editor
      text_field_tag(
        'schedule[venue][name]',
        '',
        autocomplete: 'off',
        placeholder: t('admin.venues.modal.instructions'),
        data: { target: 'admin--venue.name' }
      )
    end
  end
end
