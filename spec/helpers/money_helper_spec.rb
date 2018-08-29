# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MoneyHelper, type: :helper do
  describe '#money' do
    subject { helper.money(amount) }
    let(:amount) { Money.new(12_345) }
    let(:html) do
      '<span class="money">$123.45 <span class="currency">NZD</span></span>'
    end

    it { is_expected.to eq html }
  end
end
