# frozen_string_literal: true

module ActivitiesHelper
  ACTIVITY_PHOTO_SIZES = {
    small: 480,
    medium: 960,
    large: 1920
  }.freeze

  # TODO: responsive images
  def activity_photo(activity, size: :medium, **options)
    image_tag(
      activity_photo_url(activity, size),
      options.merge(class: class_string('activity__photo', options[:class]))
    )
  end

  private

  def activity_photo_url(activity, size)
    width = ACTIVITY_PHOTO_SIZES[size] || size
    height = width * 9 / 16
    if activity.photo.attached?
      photo_variant_url(activity.photo, width, height)
    else
      photo_placeholder_url(activity, width, height)
    end
  end

  def photo_variant_url(photo, width, height)
    photo.variant(
      resize: "#{width}x#{height}^",
      extent: "#{width}x#{height}",
      gravity: 'center'
    )
  end

  def photo_placeholder_url(activity, width, height)
    "https://via.placeholder.com/#{width}x#{height}/b6c2d6/ffffff.png?" \
      "text=#{h activity.name}"
  end
end
