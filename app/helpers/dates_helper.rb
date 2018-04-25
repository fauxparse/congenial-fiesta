# frozen_string_literal: true

module DatesHelper
  def date_range(start_date, end_date)
    [
      l(start_date, format: start_date_format(start_date, end_date)),
      l(end_date, format: :long)
    ].reject(&:blank?).join('–')
  end

  private

  def start_date_format(start_date, end_date)
    if start_date.year != end_date.year
      :long
    elsif start_date.month != end_date.month
      :same_year
    elsif start_date.day != end_date.day
      :same_month
    else
      :same_day
    end
  end
end
