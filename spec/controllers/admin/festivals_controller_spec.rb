# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FestivalsController, type: :request do
  subject { response }
  let(:user) { create(:admin) }

  before { log_in_as(user) if user.present? }

  describe 'get /admin' do
    before { get admin_root_path }

    context 'when not logged in' do
      let(:user) { nil }
      it { is_expected.to redirect_to(login_path) }
    end

    context 'when logged in as a normal user' do
      let(:user) { create(:participant, :with_password) }
      it { is_expected.to have_http_status(:unauthorized) }
    end

    context 'when logged in as an admin user' do
      it { is_expected.to have_http_status(:ok) }
      it { is_expected.to be_successful }
    end
  end

  describe 'get /:year' do
    let(:festival) { create(:festival) }
    before { get admin_festival_path(festival) }
    it { is_expected.to be_successful }
  end
end
