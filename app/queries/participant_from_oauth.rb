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
      attach_avatar_to(participant) \
        if avatar.present? && !participant.avatar.attached?
    end
  end

  def attach_avatar_to(participant)
    open(avatar) do |file|
      participant.avatar.attach(
        io: file,
        filename: File.basename(avatar),
        content_type:
          file.respond_to?(:content_type) &&
          file.content_type ||
          Rack::Mime.mime_type(File.extname(avatar))
      )
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
