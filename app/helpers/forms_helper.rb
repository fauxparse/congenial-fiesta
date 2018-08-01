# frozen_string_literal: true

module FormsHelper
  module FormBuilderAdditions
    def group(field, options = {}, &block)
      @template.content_tag(
        :div,
        options.merge(
          data: (options[:data] || {}).merge(field: field),
          class: form_group_class(field, options)
        ),
        &block
      )
    end

    def check_box_field(field, options = {}, &block)
      data = options[:data]
      options = options.except(:data).merge(
        class: @template.class_string('check-box-field', options[:class])
      )
      @template.content_tag(:div, options) do
        @template.concat check_box(field, data: data)
        @template.concat check_box_icon(field)
        @template.concat check_box_field_content(field, &block) if block_given?
      end
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
        'required' => options[:required],
        'with-errors' => errors_on?(field)
      )
    end

    def errors_on(field)
      @object.errors.full_messages_for(field)
    end

    def formatted_error_messages_for(field)
      @template.content_tag :ul, class: 'form-errors' do
        errors_on(field).uniq.each do |message|
          @template.concat @template.content_tag(:li, message)
        end
      end
    end

    def check_box_icon(field)
      label field, class: 'check-box-field-icon' do
        @template.concat @template.inline_icon(:check)
      end
    end

    def check_box_field_content(field)
      label field, class: 'check-box-field-content' do
        yield if block_given?
      end
    end
  end
end

ActionView::Helpers::FormBuilder
  .send(:include, FormsHelper::FormBuilderAdditions)
