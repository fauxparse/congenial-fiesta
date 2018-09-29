# frozen_string_literal: true

class Report
  include Enumerable

  attr_reader :festival

  def initialize(festival)
    @festival = festival
  end

  def each
    return enum_for(:each) unless block_given?

    rows.each do |row|
      datum = columns.map do |name, query|
        [name, query.call(row)]
      end
      yield datum
    end
  end

  def as_json(_options = {})
    map(&:to_h)
  end

  def to_csv
    CSV.generate(headers: true) do |csv|
      csv << columns.map(&:first).map { |col| column_name(col) }

      each do |row|
        csv << row.map(&:last)
      end
    end
  end

  def columns
    self.class.columns
  end

  def name
    self.class.report_name
  end

  def title
    I18n.t(title, scope: "reports.#{name}")
  end

  def column_name(column)
    I18n.t(
      column,
      scope: "reports.#{name}.columns",
      default: column.to_s.humanize
    )
  end

  def self.report_name
    name.demodulize.underscore.sub(/_report$/, '')
  end

  def self.columns
    @columns ||= []
  end

  def self.column(name, &block)
    columns << [name, block_given? ? block : name.to_proc]
  end
end

require_dependency 'workshops_report'
require_dependency 'finance_report'
