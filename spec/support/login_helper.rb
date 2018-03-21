# frozen_string_literal: true

module LoginHelper
  def log_in_as(participant)
    if participant.password?
      log_in_with_password(participant)
    else
      log_in_with_oauth(participant.identities.first)
    end
  end

  private

  def log_in_with_password(participant)
    post login_path,
      params: { login: { email: participant.email, password: 'p4$$w0rd' } }
  end

  def log_in_with_oauth(identity)
    setup_login_mocks(identity)
    post "/auth/#{identity.provider}/callback"
  end

  def setup_login_mocks(identity)
    OmniAuth.config.mock_auth[identity.provider.to_sym] =
      OmniAuth::AuthHash.new(mock_oauth_hash(identity))
    Rails.application.env_config['omniauth.auth'] =
      OmniAuth.config.mock_auth[identity.provider.to_sym]
  end

  def mock_oauth_hash(identity)
    OmniAuth::AuthHash.new(
      'provider' => identity.provider,
      'uid' => identity.uid,
      'info' => {
        'name' => identity.participant.name,
        'email' => identity.participant.email
      }
    )
  end
end
