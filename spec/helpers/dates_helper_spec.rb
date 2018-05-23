# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DatesHelper, type: :helper do
  subject(:text) { helper.date_range(start_date, end_date) }
  let(:start_date) { Date.civil(2018, 7, 27) }

  context 'when the end date is the same as the start date' do
    let(:end_date) { start_date }
    it { is_expected.to eq '27 July, 2018' }
  end

  context 'when the end date is the same month as the start date' do
    let(:end_date) { start_date + 1 }
    it { is_expected.to eq '27–28 July, 2018' }
  end

  context 'when the end date is the same year as the start date' do
    let(:end_date) { start_date + 5 }
    it { is_expected.to eq '27 July–1 August, 2018' }
  end

  context 'when the end date is a different year from the start date' do
    let(:end_date) { start_date + 1.year }
    it { is_expected.to eq '27 July, 2018–27 July, 2019' }
  end
end
