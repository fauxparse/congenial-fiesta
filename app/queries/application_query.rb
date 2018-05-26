# frozen_string_literal: true

class ApplicationQuery
  include Enumerable

  attr_reader :parameters

  def initialize(parameters = {})
    @parameters = self.class.const_get(:Parameters).new(parameters)
  end

  def each
    return enum_for(:each) unless block_given?
    scope(parameters).all.each do |result|
      yield result
    end
  end

  def count(extra_parameters = {})
    scope(parameters.merge(extra_parameters)).count
  end

  private

  def default_scope
    self.class.name.singularize.constantize
  end

  def scope(parameters)
    parameters.inject(default_scope) do |scope, (parameter, value)|
      value.present? ? refine_scope(scope, parameter, value) : scope
    end
  end

  def refine_scope(scope, parameter, value)
    if respond_to?(parameter, true)
      send(parameter, scope, value)
    elsif scope.respond_to?(parameter)
      scope.send(parameter, value)
    else
      scope.where(parameter => value)
    end
  end
end
