# frozen_string_literal: true

class PitchForm
  include Rails.application.routes.url_helpers

  attr_reader :pitch

  def initialize(pitch, step: nil)
    @pitch = pitch
    @current_step =
      step && selectable_steps.detect { |s| s.to_sym == step.to_sym }
  end

  def participant
    pitch.participant || pitch.build_participant
  end

  def steps
    @steps ||= build_steps(
      PitchForm::Step::Presenter,
      PitchForm::Step::Idea
    )
  end

  def each_step
    return enum_for(:each_step) unless block_given?

    seen_current_step = false
    steps.each.with_index(1) do |step, index|
      state, seen_current_step = compute_step_state(step, seen_current_step)
      yield step, step_number: index, state: state
    end
  end

  def current_step
    @current_step ||=
      steps
      .detect { |step| !step.valid? }
      .tap { |step| step&.errors&.clear }
  end

  def to_partial_path
    'pitches/form'
  end

  def save!
    Pitch.transaction do
      current_step.apply!
      next_step if current_step.valid?
    end
  end

  def url
    if pitch.persisted?
      pitch_step_path(pitch, current_step)
    else
      new_pitch_path
    end
  end

  private

  def build_steps(*klasses)
    klasses
      .flat_map { |klass| klass.factory(pitch) }
      .compact
      .tap do |steps|
        steps.each_cons(2) do |first, second|
          first.next = second
          second.previous = first
        end
      end
  end

  def compute_step_state(step, seen_current_step)
    if seen_current_step
      [:pending, true]
    elsif step == current_step
      [:current, true]
    else
      [:complete, false]
    end
  end

  def selectable_steps
    valid, invalid = steps.partition(&:valid?)
    [*valid, invalid.first].compact.map do |step|
      step.tap { |s| s.errors.clear }
    end
  end

  def next_step
    @current_step = @current_step.next
  end
end
