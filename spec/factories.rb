# frozen_string_literal: true

FactoryBot.define do
  factory :festival do
    year 2018
    start_date Date.new(2018, 10, 20)
    end_date Date.new(2018, 10, 27)
  end
end
