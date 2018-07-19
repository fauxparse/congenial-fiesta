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
    start_date do
      october = Date.new(year, 10, 14)
      october + 6 - october.wday
    end
    end_date { start_date + 7 }
    pitches_open_at { Time.zone.now }
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

    factory :admin, traits: [:with_password] do
      admin true
    end
  end

  factory :oauth_identity, class: 'Identity::Oauth' do
    provider 'twitter'
    uid { SecureRandom.uuid }
  end

  factory :password_identity, class: 'Identity::Password' do
    password 'p4$$w0rd'
  end

  factory :pitch do
    festival
    participant

    trait :submitted do
      status 'submitted'
    end

    trait :for_workshop do
      info do
        {
          presenter: {
            name: participant.name,
            city: 'Wellington',
            bio: Faker::Hipster.paragraph
          },
          code_of_conduct_accepted: true,
          activity: {
            type: 'standalone_workshop',
            name: 'Workshop',
            workshop_description: Faker::Hipster.paragraph
          }
        }
      end
    end

    trait :for_directed_performance do
      info do
        {
          presenter: {
            name: participant.name,
            city: 'Wellington',
            bio: Faker::Hipster.paragraph
          },
          code_of_conduct_accepted: true,
          activity: {
            type: 'directed_performance',
            name: 'Directed Performance',
            workshop_description: Faker::Hipster.paragraph,
            show_description: Faker::Hipster.paragraph,
            cast_size: 6
          }
        }
      end
    end

    trait :for_experimental_performance do
      info do
        {
          presenter: {
            name: participant.name,
            city: 'Wellington',
            bio: Faker::Hipster.paragraph
          },
          code_of_conduct_accepted: true,
          activity: {
            type: 'experimental_performance',
            name: 'Experimental Performance',
            workshop_description: Faker::Hipster.paragraph,
            show_description: Faker::Hipster.paragraph,
            cast_size: 6
          }
        }
      end
    end

    trait :for_return_performance do
      info do
        {
          presenter: {
            name: participant.name,
            city: 'Wellington',
            bio: Faker::Hipster.paragraph
          },
          code_of_conduct_accepted: true,
          activity: {
            type: 'return_performance',
            name: 'Return Performance',
            show_description: Faker::Hipster.paragraph,
            cast_size: 6
          }
        }
      end
    end
  end

  factory :presenter do
    activity { create(:workshop) }
    participant
  end

  factory :show do
    festival
    name 'A show'
  end

  factory :workshop do
    festival
    name 'A workshop'
  end

  factory :venue do
    name 'BATS'
    address '1 Kent Tce'
    latitude '-41.2921901197085'.to_d
    longitude '174.7858539802915'.to_d
  end
end
