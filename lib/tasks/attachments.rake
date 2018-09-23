# frozen_string_literal: true

if Rails.env.development?
  namespace :attachments do
    desc 'Purges all attachments'
    task purge: :environment do
      [[Participant, :avatar], [Activity, :photo]].each do |model, attachment|
        puts "Purging #{attachment.to_s.pluralize} from #{model.name.pluralize}"
        model.all.each do |instance|
          instance.send(attachment).purge
        end
      end
    end
  end
end
