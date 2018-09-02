# frozen_string_literal: true

require 'rails_helper'

RSpec.describe RegistrationForm::Step::ShowSelection do
  subject(:step) { RegistrationForm::Step::ShowSelection.new(form) }
  let(:form) do
    double(
      RegistrationForm,
      registration: registration,
      steps: []
    )
  end
  let(:registration) { create(:registration) }
  let(:shows) { create_list(:show, 3, festival: registration.festival) }
  let(:schedules) { shows.map { |w| create(:schedule, activity: w) } }

  describe '#to_param' do
    subject { step.to_param }
    it { is_expected.to eq 'shows' }
  end

  describe '#update' do
    let(:attributes) do
      {
        shows: {
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

    it 'completes show selection' do
      expect { step.update(attributes) }
        .to change { registration.reload.shows_saved? }
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
