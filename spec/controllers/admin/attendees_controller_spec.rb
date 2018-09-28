# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::AttendeesController, type: :request do
  subject { response }
  let(:festival) { create(:festival) }
  let!(:schedule) { create(:schedule, activity: show) }
  let(:show) { create(:show, festival: festival) }
  let(:admin) { create(:admin) }

  before { log_in_as(admin) }

  describe 'GET /admin/:year/shows/:slug/attendees' do
    before { get admin_show_attendees_path(festival, show) }
    it { is_expected.to be_successful }
  end
end
