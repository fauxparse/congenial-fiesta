# frozen_string_literal: true

class ParticipantMailer < ApplicationMailer
  helper MoneyHelper

  def registration_confirmation_email(registration)
    @registration = registration
    @participant = registration.participant
    @festival = registration.festival
    @cart = Cart.new(@registration, include_pending: false)
    mail to: @participant.email, subject: t('.subject', festival: @festival)
  end

  def waitlist_success_email(waitlist)
    @registration = waitlist.registration
    @schedule = waitlist.schedule
    @participant = @registration.participant
    mail to: @participant.email,
      subject: t('.subject', activity: @schedule.activity.name)
  end

  def allocation_confirmation_email(registration)
    @registration = registration
    @participant = registration.participant
    @workshops =
      registration
        .selections
        .allocated
        .joins(schedule: :activity)
        .merge(Workshop.all)
        .merge(Schedule.with_details)
        .all
        .map(&:schedule)
        .sort_by(&:starts_at)
    @waitlists =
      registration
        .waitlists
        .joins(schedule: :activity)
        .merge(Workshop.all)
        .merge(Schedule.with_details)
        .all
        .map(&:schedule)
        .sort_by(&:starts_at)
    mail to: @participant.email, subject: t('.subject')
  end
end
