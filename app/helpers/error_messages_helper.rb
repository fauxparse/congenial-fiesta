# frozen_string_literal: true

module ErrorMessagesHelper
  module FormBuilderAdditions
    def group(field, options = {}, &block)
      @template.content_tag(
        :div,
        options.merge(class: form_group_class(field, options)),
        &block
      )
    end

    def error_messages_for(field)
      formatted_error_messages_for(field) if errors_on?(field)
    end

    def errors_on?(field)
      @object.errors.include?(field.to_sym)
    end

    private

    def form_group_class(field, options)
      @template.class_string(
        'form-field',
        options[:class],
        'with-errors' => errors_on?(field)
      )
    end

    def errors_on(field)
      @object.errors.full_messages_for(field)
    end

    def formatted_error_messages_for(field)
      @template.content_tag :ul, class: 'form-errors' do
        errors_on(field).each do |message|
          @template.concat @template.content_tag(:li, message)
        end
      end
    end
  end
end

ActionView::Helpers::FormBuilder
  .send(:include, ErrorMessagesHelper::FormBuilderAdditions)
