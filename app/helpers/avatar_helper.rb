# frozen_string_literal: true

module AvatarHelper
  def avatar(participant, size: 80, default_icon: :user, **options)
    options = options.merge(class: class_string('avatar', options[:class]))
    content_tag :div, options do
      if participant.avatar.attached?
        concat avatar_image(participant, size)
      else
        concat icon(default_icon)
      end
    end
  end

  private

  def avatar_thumbnail_url(avatar, size: 80)
    avatar.variant(
      resize: "#{size}x#{size}^",
      extent: "#{size}x#{size}",
      gravity: 'center'
    )
  end

  def avatar_image(participant, size)
    image_tag(
      avatar_thumbnail_url(participant.avatar, size: size),
      alt: participant.name
    )
  end
end
