# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  helper EmailHelper

  default from: 'registrations@nzimprovfestival.co.nz'
  layout 'mailer'
end
