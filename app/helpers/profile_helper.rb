# frozen_string_literal: true

module ProfileHelper
  def oauth_accounts(participant)
    Identity
      .providers
      .except(:developer)
      .keys
      .map do |provider|
        oauth_account(participant, provider) ||
          Identity::Oauth.new(provider: provider)
      end
  end

  def connect_account_link(account)
    link_to(
      t(account.connected? ? :disconnect : :connect, scope: 'profiles.show'),
      connect_profile_path(account.provider),
      method: account.connected? ? :delete : :get,
      class: class_string('button', 'button-primary': !account.connected?)
    )
  end

  private

  def oauth_account(participant, provider)
    participant
      .identities
      .detect { |identity| identity.provider == provider }
  end
end
