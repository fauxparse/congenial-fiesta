# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DateValidator, type: :validator do
  def test_class(&block)
    Class.new(Struct.new(:start_date, :end_date)).tap do |klass|
      klass.send(:include, ActiveModel::Validations)
      klass.instance_eval(&block)
    end
  end

  def test_instance(&block)
    test_class(&block).new(start_date, end_date)
  end

  before { instance.validate }

  let(:start_date) { Date.new(2018, 4, 1) }
  let(:end_date) { Date.new(2018, 7, 27) }

  context 'validating a date is after a given constant' do
    subject(:instance) do
      test_instance do
        validates :start_date, date: { after: Date.new(2017, 12, 31) }
      end
    end

    context 'with a valid start_date' do
      let(:start_date) { Date.new(2018, 1, 1) }

      it { is_expected.to be_valid }
    end

    context 'with an invalid start_date' do
      let(:start_date) { Date.new(2017, 1, 1) }

      it { is_expected.not_to be_valid }
    end
  end

  context 'validating one date is before another' do
    subject(:instance) do
      test_instance do
        validates :start_date, date: { before: :end_date }
      end
    end

    context 'with dates in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with dates in the wrong order' do
      let(:start_date) { end_date + 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:start_date) }
    end

    context 'with two dates the same' do
      let(:start_date) { end_date }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:start_date) }
    end
  end

  context 'validating one date is on or after another' do
    subject(:instance) do
      test_instance do
        validates :end_date, date: { on_or_after: :start_date }
      end
    end

    context 'with dates in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with dates in the wrong order' do
      let(:end_date) { start_date - 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:end_date) }
    end

    context 'with two dates the same' do
      let(:end_date) { start_date }

      it { is_expected.to be_valid }
    end
  end

  context 'using a block for date validation' do
    subject(:instance) do
      test_instance do
        validates :end_date,
          date: { on_or_after: ->(record) { record.start_date } }
      end
    end

    context 'with dates in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with dates in the wrong order' do
      let(:end_date) { start_date - 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:end_date) }
    end

    context 'with two dates the same' do
      let(:end_date) { start_date }

      it { is_expected.to be_valid }
    end
  end
end
