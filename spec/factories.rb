# frozen_string_literal: true

FactoryBot.define do
  sequence :email do |n|
    "participant_#{n}@example.com"
  end

  sequence :name do |n|
    "Participant #{n}"
  end

  factory :festival do
    year 2018
    start_date Date.new(2018, 10, 20)
    end_date Date.new(2018, 10, 27)
  end

  factory :participant do
    name
    email

    trait :with_password do
      after(:build) do |participant|
        participant.identities << build(:password_identity)
      end
    end

    trait :with_oauth do
      after(:build) do |participant|
        participant.identities << build(:oauth_identity)
      end
    end

    trait :with_avatar do
      after(:build) do |participant|
        File.open('spec/support/files/avatar.jpg') do |file|
          participant.avatar.attach(
            io: file, filename: 'avatar.jpg', content_type: 'image/jpeg'
          )
        end
      end
    end
  end

  factory :oauth_identity, class: 'Identity::Oauth' do
    provider 'twitter'
    uid { SecureRandom.uuid }
  end

  factory :password_identity, class: 'Identity::Password' do
    password 'p4$$w0rd'
  end
end
