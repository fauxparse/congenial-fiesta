# frozen_string_literal: true

class WorkshopAllocationForm
  include Cry

  def initialize(festival, params)
    @festival = festival
    @params = params
  end

  def update(dry_run: true)
    update_exclusions((params[:exclude] || []).reject(&:blank?).map(&:to_i))
    if dry_run
      publish :dry_run
    else
      ConfirmWorkshopAllocations.new(allocator.results).call
      publish :allocated
    end
  end

  delegate :magic_number, to: :allocator
  delegate :each, to: :allocations

  private

  attr_reader :festival, :params

  def allocator
    @allocator ||=
      AllocateWorkshops.with_magic_number(festival, params[:magic_number])
  end

  def allocations
    @allocations ||= allocator.tap(&:call).results
  end

  def update_exclusions(ids)
    existing =
      Selection.excluded.joins(:activity).merge(festival.workshops).pluck(:id)
    Selection.transaction do
      festival.selections.where(id: existing - ids).update_all(excluded: false)
      festival.selections.where(id: ids - existing).update_all(excluded: true)
    end
  end
end
