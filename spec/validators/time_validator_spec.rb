# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TimeValidator, type: :validator do
  def test_class(&block)
    Class.new(Struct.new(:start_time, :end_time)).tap do |klass|
      klass.send(:include, ActiveModel::Validations)
      klass.instance_eval(&block)
    end
  end

  def test_instance(&block)
    test_class(&block).new(start_time, end_time)
  end

  before { instance.validate }

  let(:start_time) { Time.zone.local(2018, 7, 27, 0, 0) }
  let(:end_time) { Time.zone.local(2018, 7, 27, 13, 37) }

  context 'validating a time is after a given constant' do
    subject(:instance) do
      test_instance do
        validates :start_time, time: { after: Time.zone.local(2017, 12, 31) }
      end
    end

    context 'with a valid start_time' do
      let(:start_time) { Time.zone.local(2018, 1, 1) }

      it { is_expected.to be_valid }
    end

    context 'with an invalid start_time' do
      let(:start_time) { Time.zone.local(2017, 1, 1) }

      it { is_expected.not_to be_valid }
    end
  end

  context 'validating one time is before another' do
    subject(:instance) do
      test_instance do
        validates :start_time, time: { before: :end_time }
      end
    end

    context 'with times in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with times in the wrong order' do
      let(:start_time) { end_time + 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:start_time) }
    end

    context 'with two times the same' do
      let(:start_time) { end_time }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:start_time) }
    end
  end

  context 'validating one time is at or after another' do
    subject(:instance) do
      test_instance do
        validates :end_time, time: { at_or_after: :start_time }
      end
    end

    context 'with times in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with times in the wrong order' do
      let(:end_time) { start_time - 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:end_time) }
    end

    context 'with two times the same' do
      let(:end_time) { start_time }

      it { is_expected.to be_valid }
    end
  end

  context 'using a block for time validation' do
    subject(:instance) do
      test_instance do
        validates :end_time,
          time: { at_or_after: ->(record) { record.start_time } }
      end
    end

    context 'with times in the correct order' do
      it { is_expected.to be_valid }
    end

    context 'with times in the wrong order' do
      let(:end_time) { start_time - 1 }

      it { is_expected.not_to be_valid }
      it { is_expected.to have_exactly(1).error_on(:end_time) }
    end

    context 'with two times the same' do
      let(:end_time) { start_time }

      it { is_expected.to be_valid }
    end
  end
end
