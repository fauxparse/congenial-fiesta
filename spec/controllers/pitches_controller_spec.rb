# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PitchesController, type: :request do
  before { log_in_as(participant) }
  let(:participant) { create(:participant, :with_password) }

  describe 'get /pitches' do
    it 'returns http success' do
      get pitches_path
      expect(response).to be_successful
    end
  end
end
