# frozen_string_literal: true

require 'rails_helper'

RSpec.describe StaticPagesHelper, type: :helper do
  describe '#last_updated' do
    subject(:html) { helper.last_updated(date) }
    let(:date) { Date.new(2018, 4, 1) }
    let(:expected_html) do
      '<div class="last-updated">Last updated: <b>1 April, 2018</b></div>'
    end

    it { is_expected.to eq expected_html }
  end
end
