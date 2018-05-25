# frozen_string_literal: true

module Admin
  module NavigationHelper
    def navigation_link(name, url_options, icon: nil)
      link_to url_options, class: navigation_link_class(url_options) do
        concat navigation_link_icon(icon || name)
        concat navigation_link_text(name)
        yield if block_given?
      end
    end

    private

    def navigation_link_class(url_options)
      class_string(
        'navigation__link',
        'navigation__link--current': current_page?(url_options)
      )
    end

    def navigation_link_icon(icon_name)
      icon(icon_name, class: 'navigation__link-icon')
    end

    def navigation_link_text(name)
      content_tag(
        :span,
        t(name, scope: 'admin.navigation'),
        class: 'navigation__link-text'
      )
    end
  end
end
