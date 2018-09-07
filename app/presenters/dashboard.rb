# frozen_string_literal: true

class Dashboard
  attr_reader :festival, :admin

  def initialize(festival, admin)
    @festival = festival
    @admin = admin
  end

  def widgets
    @widgets ||= [
      Dashboard::Summary.new(festival)
    ]
  end

  def to_partial_path
    'admin/dashboard/dashboard'
  end
end
