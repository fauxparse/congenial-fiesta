# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::FestivalsController, type: :request do
  subject { response }
  let(:user) { create(:admin) }

  before { log_in_as(user) if user.present? }

  describe 'get /admin' do
    context 'when there is no festival' do
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
        it { is_expected.to be_successful }
      end
    end

    context 'when there is a festival' do
      let!(:festival) { create(:festival) }
      before { get admin_root_path }
      it { is_expected.to redirect_to admin_festival_path(festival) }
    end

    context 'when there is no current festival' do
      let!(:festival) { create(:festival, year: Time.zone.today.year - 1) }
      before { get admin_root_path }
      it { is_expected.to be_successful }
    end
  end

  describe 'get /admin/:year' do
    let(:festival) { create(:festival) }
    before { get admin_festival_path(festival) }
    it { is_expected.to be_successful }
  end

  describe 'get /admin/festivals/new' do
    before { get new_admin_festival_path }
    it { is_expected.to be_successful }
  end

  describe 'post /admin/festivals' do
    before { post admin_festivals_path, params: festival_params }

    context 'with valid params' do
      let(:festival_params) { { festival: attributes_for(:festival) } }
      it { is_expected.to redirect_to admin_festival_path(Festival.last) }
    end

    context 'with invalid params' do
      let(:festival_params) { {} }
      it { is_expected.to be_successful }
    end
  end
end
