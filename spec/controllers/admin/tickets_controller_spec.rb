# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::TicketsController, type: :request do
  subject { response }
  let(:festival) { create(:festival) }
  let(:show) { create(:show, festival: festival) }
  let!(:schedule) { create(:schedule, activity: show) }

  before { log_in_as(participant) }

  context 'when logged in as a normal participant' do
    let(:participant) { create(:participant, :with_password) }

    describe 'GET /admin/:year/tickets' do
      before { get admin_tickets_path(festival) }
      it { is_expected.not_to be_successful }
    end

    describe 'GET /admin/:year/tickets/:id' do
      before { get admin_ticket_path(festival, show) }
      it { is_expected.not_to be_successful }
    end
  end

  context 'when logged in as BATS staff' do
    let(:participant) do
      create(:participant, :with_password, role_list: %w(box_office))
    end

    describe 'GET /admin/:year/tickets' do
      before { get admin_tickets_path(festival) }
      it { is_expected.to be_successful }
    end

    describe 'GET /admin/:year/tickets/:id' do
      before { get admin_ticket_path(festival, show) }
      it { is_expected.to be_successful }
    end
  end
end
