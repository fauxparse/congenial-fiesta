# frozen_string_literal: true

class ParticipantFromOauth
  def initialize(oauth_hash, existing_participant = nil)
    @oauth_hash = oauth_hash.deep_symbolize_keys
    @participant = existing_participant
  end

  def participant
    participant_with_avatar
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

  def participant_with_avatar
    identity.participant.tap do |participant|
      if participant.avatar.blank? && avatar.present?
        participant.avatar.attach(
          io: File.open(avatar),
          filename: File.basename(avatar),
          content_type: 'image/jpg'
        )
      end
    end
  end

  def find_or_create_participant
    @participant ||
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

  def avatar
    oauth_hash[:info][:image]
  end
end
