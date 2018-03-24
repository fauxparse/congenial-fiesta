# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'registrations@nzimprovfestival.co.nz'
  layout 'mailer'
end
