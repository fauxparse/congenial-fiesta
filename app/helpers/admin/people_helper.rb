# frozen_string_literal: true

module Admin
  module PeopleHelper
    def person_name_editor
      text_field_tag(
        'person[name]',
        '',
        autocomplete: 'off',
        data: { target: 'admin--person.name' }
      )
    end
  end
end
