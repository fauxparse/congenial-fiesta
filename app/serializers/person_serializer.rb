# frozen_string_literal: true

class PersonSerializer < Primalize::Single
  include Rails.application.routes.url_helpers

  attributes(
    id: string,
    name: string,
    email: optional(string),
    admin: boolean,
    avatar: optional(string),
    city: optional(string),
    country: optional(string),
    country_code: optional(string),
    bio: optional(string)
  )

  def id
    object.to_param.to_s
  end

  def avatar
    polymorphic_url(avatar_variant, only_path: true) if object.avatar.attached?
  end

  private

  def avatar_variant
    object.avatar.variant(
      resize: '80x80^',
      extent: '80x80',
      gravity: 'center'
    )
  end
end
