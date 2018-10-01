# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckWaitlist do
  subject(:service) { CheckWaitlist.new(schedule) }

  let(:workshop) { create(:workshop) }
  let(:festival) { workshop.festival }
  let(:schedule) { create(:schedule, activity: workshop, maximum: 1) }
  let(:registration) { create(:registration, festival: workshop.festival) }

  before do
    Waitlist.find_or_create_by!(schedule: schedule, registration: registration)
  end

  describe '#call' do
    it 'removes the waitlist entry' do
      expect { service.call }.to change(Waitlist, :count).by(-1)
    end

    it 'allocates a place' do
      expect { service.call }.to change { Selection.allocated.count }.by(1)
    end

    context 'when the participant has multiple waitlists' do
      let(:alternate) { create(:workshop, festival: festival) }
      let(:alternate_schedule) { create(:schedule, activity: alternate) }
      let(:later) { create(:workshop, festival: festival) }
      let(:later_schedule) do
        create(
          :schedule,
          activity: later,
          starts_at: alternate_schedule.starts_at + 1.day
        )
      end

      before do
        [alternate_schedule, later_schedule].each do |s|
          create(:waitlist, registration: registration, schedule: s)
        end
      end

      it 'removes other waitlists in the same slot' do
        expect(alternate_schedule.slot).to eq schedule.slot
        expect { service.call }
          .to change { alternate_schedule.waitlists.count }
          .by(-1)
      end

      it 'does not affect waitlists in other slots' do
        expect { service.call }.not_to change { later_schedule.waitlists.count }
      end
    end

    context 'when selected during registration' do
      let!(:selection) do
        create(
          :selection,
          registration: registration,
          schedule: schedule,
          state: :registered
        )
      end

      it 'does not delete the selection' do
        expect { service.call }.not_to change(Selection, :count)
      end

      it 'allocates the selection' do
        expect { service.call }
          .to change { selection.reload.state }
          .from('registered')
          .to('allocated')
      end

      context 'and the participant is in another workshop' do
        let(:alternate) { create(:workshop, festival: festival) }
        let(:alternate_schedule) { create(:schedule, activity: alternate) }
        let!(:alternative_selection) do
          create(
            :selection,
            registration: registration,
            schedule: alternate_schedule,
            state: :allocated
          )
        end

        it 'deletes the other selection' do
          expect { service.call }
            .to change { Selection.where(id: alternative_selection.id).exists? }
            .from(true)
            .to(false)
        end

        it 'allocates the first choice' do
          expect { service.call }
            .to change { selection.reload.state }
            .from('registered')
            .to('allocated')
        end
      end

      context 'when the workshop is full' do
        let!(:selection) do
          create(
            :selection,
            schedule: schedule,
            registration: create(:registration, festival: festival),
            state: 'allocated'
          )
        end

        it 'does not allocate the selection' do
          expect { service.call }.not_to change { selection.reload.state }
        end

        it 'does not remove the waitlist entry' do
          expect { service.call }.not_to change(Waitlist, :count)
        end

        it 'does not add or remove selections' do
          expect { service.call }.not_to change(Selection, :count)
        end
      end
    end

    context 'when the participant is on multiple waitlists' do
      let(:workshops) do
        (1..3).map do |i|
          create(:schedule, activity: create(:workshop, festival: festival))
            .tap do |schedule|
              registration.selections.create(
                schedule: schedule,
                position: i,
                state: :registered
              )
              registration.waitlists.create(schedule: schedule)
            end
        end
      end

      let(:schedule) { workshops.second }

      it 'allocates the workshop place' do
        expect { service.call }
          .to change { workshops.second.selections.allocated.count }.by(1)
          .and change { registration.selections.allocated.count }.by(1)
      end

      it 'removes the waitlist entry' do
        expect { service.call }
          .to change { workshops.second.waitlists.count }.by(-1)
      end

      it 'removes the waitlist entries for lower-priority choices' do
        expect { service.call }
          .to change { workshops.third.waitlists.count }.by(-1)
      end

      it 'does not remove the waitlist entries for lower-priority choices' do
        expect { service.call }
          .not_to change { workshops.first.waitlists.count }
      end
    end

    context 'when the workshop is full' do
      let!(:selection) do
        create(
          :selection,
          schedule: schedule,
          registration: create(:registration, festival: festival),
          state: 'allocated'
        )
      end

      it 'does not remove the waitlist entry' do
        expect { service.call }.not_to change(Waitlist, :count)
      end

      it 'does not add or remove selections' do
        expect { service.call }.not_to change(Selection, :count)
      end
    end
  end
end
