# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FormsHelper, type: :helper do
  class DummyFormObject < Struct.new(:field)
    include ActiveModel::Validations
    validates :field, presence: true
  end

  let(:object) { DummyFormObject.new(field_value).tap(&:validate) }
  let(:form) do
    ActionView::Base.default_form_builder.new(:form, object, helper, {})
  end

  describe '#check_box_field' do
    let(:field_value) { true }

    context 'when no block is given' do
      subject { form.check_box_field(:field) }
      it { is_expected.not_to include('check-box-field-content') }
    end

    context 'when a block is given' do
      subject do
        form.check_box_field(:field) do
          'text'
        end
      end
      it { is_expected.to include('text') }
    end
  end

  describe '#group' do
    subject { form.group(:field) {} }

    context 'when the field is valid' do
      let(:field_value) { 'value' }
      it { is_expected.not_to include('with-errors') }
    end

    context 'when the field is not valid' do
      let(:field_value) { '' }
      it { is_expected.to include('with-errors') }
    end
  end

  describe '#error_messages_for' do
    subject { form.error_messages_for(:field) }

    context 'when the field is valid' do
      let(:field_value) { 'value' }
      it { is_expected.to be_blank }
    end

    context 'when the field is not valid' do
      let(:field_value) { '' }
      let(:expected_html) do
        '<ul class="form-errors"><li>Field can&#39;t be blank</li></ul>'
      end

      it { is_expected.to eq expected_html }
    end
  end

  describe '#errors_on?' do
    subject { form.errors_on?(:field) }

    context 'when the field is valid' do
      let(:field_value) { 'value' }
      it { is_expected.to be false }
    end

    context 'when the field is not valid' do
      let(:field_value) { '' }
      it { is_expected.to be true }
    end
  end
end
