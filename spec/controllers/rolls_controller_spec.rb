# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RollsController, type: :request do
  subject { response }
  let(:presenter) { create(:presenter) }
  let(:teacher) { presenter.participant }
  let(:workshop) { presenter.activity }
  let(:festival) { workshop.festival }
  let(:participant) { create(:participant) }

  describe 'GET /:year/workshops/:id/roll' do
    before do
      create(:password_identity, participant: participant)
      participant.reload
      log_in_as participant
      get roll_path(festival, workshop)
    end

    context 'as a regular participant' do
      it { is_expected.to redirect_to root_path }
    end

    context 'as a teacher' do
      let(:participant) { teacher }
      it { is_expected.to be_successful }
    end
  end
end
