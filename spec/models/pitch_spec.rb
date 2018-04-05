# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch, type: :model do
  subject(:pitch) { build(:pitch) }

  it { is_expected.to be_draft }

  describe '#info' do
    subject(:info) { pitch.info }
    it { is_expected.to be_a Pitch::Info }

    it 'is serialized correctly' do
      pitch.info.presenter.name = 'Test'
      pitch.save
      expect { pitch.reload }.not_to change { pitch.info.presenter.name }
    end
  end
end
