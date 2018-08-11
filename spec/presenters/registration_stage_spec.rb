# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationStage do
  subject(:stage) { RegistrationStage.new(festival) }
  let(:festival) { create(:festival) }

  after { Timecop.return }

  context 'before registration opens' do
    before { Timecop.freeze(festival.registrations_open_at - 1.day) }

    it { is_expected.not_to be_open }
    it { is_expected.not_to be_earlybird }
  end

  context 'during earlybird registration' do
    before { Timecop.freeze(festival.registrations_open_at + 1.day) }

    it { is_expected.to be_open }
    it { is_expected.to be_earlybird }
  end

  context 'after earlybird registration' do
    before { Timecop.freeze(festival.earlybird_cutoff + 1.day) }

    it { is_expected.to be_open }
    it { is_expected.not_to be_earlybird }
  end

  context 'after the festival' do
    before { Timecop.freeze(festival.end_date + 1.day) }

    it { is_expected.not_to be_open }
    it { is_expected.not_to be_earlybird }
  end
end
