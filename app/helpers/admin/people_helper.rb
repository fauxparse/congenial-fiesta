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

    def edit_admin_registration_link(festival, person, &block)
      link_to(admin_person_registration_path(festival, person), &block) \
        if person.registrations.any? { |r| r.festival_id == festival.id }
    end
  end
end
