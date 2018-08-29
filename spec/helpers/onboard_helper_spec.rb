# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OnboardHelper, type: :helper do
  describe '#onboard_step' do
    subject { helper.onboard_step { 'test' } }
    let(:html) do
      '<section class="onboard__step" data-target="onboard.step">test</section>'
    end

    it { is_expected.to eq html }
  end
end
