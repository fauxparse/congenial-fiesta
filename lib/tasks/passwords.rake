# frozen_string_literal: true

if Rails.env.development?
  namespace :passwords do
    desc 'Reset all passwords'
    task reset: :environment do
      PASSWORD = 'P4$$w0rd'

      Identity::Password.all.each do |identity|
        identity.update!(password: PASSWORD, password_confirmation: PASSWORD)
      end
    end
  end
end
