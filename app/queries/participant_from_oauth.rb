# frozen_string_literal: true

class ParticipantFromOauth
  def initialize(oauth_hash)
    @oauth_hash = oauth_hash.deep_symbolize_keys
  end

  def participant
    identity.participant
  end

  private

  attr_reader :oauth_hash, :existing_participant

  def identity
    @identity ||=
      Identity.find_by(provider: provider, uid: uid) ||
      new_identity
  end

  def new_identity
    Identity::Oauth.create!(
      provider: provider,
      uid: uid,
      participant: find_or_create_participant
    )
  end

  def find_or_create_participant
    Participant.with_email(email).first ||
      Participant.create!(name: name, email: email)
  end

  def provider
    oauth_hash[:provider]
  end

  def uid
    oauth_hash[:uid]
  end

  def name
    oauth_hash[:info][:name]
  end

  def email
    oauth_hash[:info][:email]
  end
end
