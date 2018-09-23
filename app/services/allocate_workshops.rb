# frozen_string_literal: true

class AllocateWorkshops
  attr_reader :festival, :results, :jostle_amount, :seed

  def initialize(festival, jostle: 0.5, seed: rand(0x100000000))
    @festival = festival
    @jostle_amount = jostle
    @seed = seed
  end

  def call
    srand(seed)
    @results = slots.transform_values do |schedules|
      matches = matchmaker(schedules).perform
      matches.by_target.merge(nil => unmatched_candidates(matches))
    end
    true
  end

  def magic_number
    '%02x%08x' % [(jostle_amount * 100).to_i, seed]
  end

  def self.with_magic_number(festival, magic_number)
    if magic_number.blank?
      new(festival)
    else
      new(
        festival,
        jostle: magic_number[0, 2].to_i(16) / 100.0,
        seed: magic_number[2..-1].to_i(16)
      )
    end
  end

  private

  def schedules
    @schedules ||=
      festival
      .schedules
      .with_details
      .with_selections
      .references(:activities)
      .merge(Workshop.all)
      .sorted
  end

  def slots
    @slots = schedules.group_by(&:starts_at)
  end

  def targets(schedules)
    schedules
      .map { |s| [s, [sorted_candidates(s), remaining_capacity(s)]] }
      .to_h
  end

  def sorted_candidates(schedule)
    schedule
      .selections
      .reject(&:pending?)
      .reject(&:excluded?)
      .sort_by { |s| s.registration.completed_at }
      .map(&:registration)
      .jostle(jostle_amount)
  end

  def remaining_capacity(schedule)
    schedule.maximum - schedule.selections.select(&:allocated?).size
  end

  def candidates(schedules)
    schedules
      .flat_map(&:selections)
      .select(&:registered?)
      .group_by(&:registration)
      .transform_values do |selections|
        selections.reject(&:excluded).sort.map(&:schedule)
      end
  end

  def matchmaker(schedules)
    MatchyMatchy::MatchMaker.new(
      targets: targets(schedules),
      candidates: candidates(schedules)
    )
  end

  def unmatched_candidates(matches)
    matches.by_candidate.to_a.select { |_, target| target.nil? }.map(&:first)
  end
end
