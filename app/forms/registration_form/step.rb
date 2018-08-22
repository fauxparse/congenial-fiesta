# frozen_string_literal: true

class RegistrationForm
  class Step
    include ActiveModel::Conversion
    include ActiveModel::Naming
    include ActiveModel::Validations

    attr_reader :form

    def initialize(form)
      @form = form
    end

    def to_param
      self.class.name.demodulize.underscore
    end

    def model_name
      registration.model_name
    end

    def to_partial_path
      "registrations/steps/#{to_param}"
    end

    def label
      I18n.t(to_param, scope: 'registration.steps')
    end

    def sublabel
      nil
    end

    def first?
      index.zero?
    end

    def last?
      self == form.steps.last
    end

    def current?
      self == form.current_step
    end

    def state
      if current?
        :current
      elsif complete?
        :complete
      else
        :pending
      end
    end

    def previous
      first? ? nil : form.steps[index - 1]
    end

    def previous_steps
      first? ? [] : [*previous.previous_steps, previous]
    end

    def next
      last? ? nil : form.steps[index + 1]
    end

    def complete?
      if @complete.nil?
        existing_errors = errors.dup
        errors.clear
        @complete = valid? && previous_steps.all?(&:complete?)
        errors.clear
        errors.merge! existing_errors
      end
      @complete
    end

    def update(attributes = {})
      assign_attributes(attributes)
      @complete = nil
      valid? && save
    end

    def eql?(other)
      (to_param == other.to_param) || super
    end

    delegate :registration, to: :form

    delegate :permitted_attributes, to: :class

    def respond_to_missing?(symbol, include_all)
      registration.respond_to?(symbol, include_all)
    end

    def method_missing(name, *args)
      if registration.respond_to?(name)
        registration.send(name, *args)
      else
        super
      end
    end

    def self.permit(*attributes)
      @permitted_attributes ||= []
      @permitted_attributes.push(*attributes)
    end

    def self.permitted_attributes
      @permitted_attributes || []
    end

    private

    def index
      form.steps.find_index(self) || 0
    end

    def assign_attributes(attributes)
      attributes.each_pair do |attr, value|
        send("#{attr}=", value)
      end
    end

    def save
      registration.save
    end
  end
end
