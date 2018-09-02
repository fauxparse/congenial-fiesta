# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TimetableHelper, type: :helper do
  describe '#time_range' do
    subject { time_range(start_time, end_time) }
    let(:start_time) { Time.zone.now.midnight.change(hour: 9) }
    let(:end_time) { start_time.change(hour: 17, min: 30) }

    it { is_expected.to eq '9:00AM–5:30PM' }
  end
end
