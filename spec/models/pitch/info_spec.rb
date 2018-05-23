# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Pitch::Info do
  subject(:info) { Pitch::Info.new(data) }
  let(:data) { {} }

  describe '#presenter' do
    subject(:presenter) { info.presenter }
    it { is_expected.to be_a Pitch::PresenterInfo }

    context 'when data exists' do
      let(:data) { { presenter: { name: 'Test' } } }

      it 'has the right data' do
        expect(info.presenter.name).to eq 'Test'
      end
    end
  end
end
