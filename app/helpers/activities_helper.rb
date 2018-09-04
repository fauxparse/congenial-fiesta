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

  def activity_levels(activity)
    levels = activity.sorted_level_list.map(&:to_sym)
    return unless levels.any?

    content_tag :div, class: 'activity__levels' do
      Workshop.levels.each do |level|
        concat activity_level(level) if levels.include?(level)
      end
    end
  end

  def activity_permalink(activity)
    send(:"#{activity.type.underscore}_url", festival, activity)
  end

  def activity_opengraph_photo(activity)
    if activity.photo.attached?
      full_url_for(photo_variant_url(activity.photo, 1200, 628))
    else
      image_url('facebook.png')
    end
  end

  private

  def activity_photo_url(activity, size)
    width = ACTIVITY_PHOTO_SIZES[size] || size
    height = width * 9 / 16
    if Rails.env.production? && activity.photo.attached?
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

  def activity_level(level)
    content_tag(
      :span,
      content_tag(:span, t(level, scope: 'activity.levels')),
      data: { level: level },
      class: 'activity__level'
    )
  end
end
