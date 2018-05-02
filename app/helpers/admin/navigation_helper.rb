module Admin::NavigationHelper
  def navigation_link(text, url_options, icon: nil)
    link_to url_options, class: navigation_link_class(url_options) do
      concat navigation_link_icon(icon || text.underscore.to_sym)
      concat navigation_link_text(text)
      yield if block_given?
    end
  end

  private

  def navigation_link_class(url_options)
    class_string(
      'navigation__link',
      :'navigation__link--current' => current_page?(url_options)
    )
  end

  def navigation_link_icon(icon_name)
    icon(icon_name, class: 'navigation__link-icon')
  end

  def navigation_link_text(text)
    content_tag :span, text, class: 'navigation__link-text'
  end
end
