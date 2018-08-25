# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm::Step::WorkshopSelection do
  subject(:step) { RegistrationForm::Step::WorkshopSelection.new(form) }
  let(:form) do
    double(
      RegistrationForm,
      registration: registration,
      steps: []
    )
  end
  let(:registration) { create(:registration) }
  let(:workshops) { create_list(:workshop, 3, festival: registration.festival) }
  let(:schedules) { workshops.map { |w| create(:schedule, activity: w) } }

  describe '#to_param' do
    subject { step.to_param }
    it { is_expected.to eq 'workshops' }
  end

  describe '#update' do
    let(:attributes) do
      {
        workshops: {
          schedules.second.id.to_s => 1,
          schedules.first.id.to_s => 2
        }
      }
    end

    it 'completes the step' do
      expect { step.update(attributes) }
        .to change { step.complete? }
        .from(false)
        .to(true)
    end

    it 'completes workshop selection' do
      expect { step.update(attributes) }
        .to change { registration.reload.workshop_preferences_saved? }
        .from(false)
        .to(true)
    end

    it 'creates preferences' do
      expect { step.update(attributes) }
        .to change(Selection, :count)
        .by(2)
    end

    context 'with existing preferences' do
      before do
        schedules.each do |schedule|
          registration.selections.create(schedule: schedule)
        end
      end

      it 'deletes the old preference' do
        expect { step.update(attributes) }
          .to change(Selection, :count)
          .by(-1)
      end

      it 'changes the order' do
        step.update(attributes)
        expect(registration.reload.selections.map(&:schedule_id))
          .to eq [schedules.second.id, schedules.first.id]
      end
    end
  end
end
