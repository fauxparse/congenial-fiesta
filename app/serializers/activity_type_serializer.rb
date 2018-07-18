# frozen_string_literal: true

class ActivityTypeSerializer < Primalize::Single
  attributes(
    name: string,
    label: string
  )

  def label
    I18n.t(object.name.underscore, scope: 'activity.types')
  end
end
