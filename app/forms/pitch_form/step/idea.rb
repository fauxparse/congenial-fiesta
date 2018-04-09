# frozen_string_literal: true

class PitchForm
  class Step
    class Idea < Step
      validates :name, presence: true

      def attributes=(attributes)
        info.activity = activity_specific_attributes(attributes)
      end

      def activity
        info.activity
      end

      def permit(params)
        klass = activity_type_class(params)
        params.permit(activity: [:type, *klass.properties, { levels: [] }])
      end

      def types
        %w[
          standalone_workshop
          full_day_workshop
          weekend_workshop
          directed_performance
          experimental_performance
        ]
      end

      def method_missing(name, *args)
        if respond_to_missing?(name)
          activity.send(name, *args)
        else
          super
        end
      end

      def respond_to_missing?(name, include_all = false)
        activity.class.properties.include?(name.to_s.sub(/=$/, '').to_sym) ||
          super
      end

      private

      def activity_specific_attributes(attributes)
        klass = activity_type_class(attributes)
        attributes = (attributes[:activity] || {}).slice(*klass.properties)
        klass.new(attributes.to_h.deep_symbolize_keys)
      end

      def activity_type_class(attributes)
        type = attributes.dig(:activity, :type) || activity.type
        Pitch.const_get("#{type}_info".camelize)
      end
    end
  end
end
