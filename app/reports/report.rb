# frozen_string_literal: true

class Report
  include Enumerable

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
    self.class.name.demodulize.underscore.sub(/_report$/, '')
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

  def self.columns
    @columns ||= []
  end

  def self.column(name, &block)
    columns << [name, block]
  end
end
