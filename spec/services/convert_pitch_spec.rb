# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ConvertPitch, type: :service do
  subject(:service) { ConvertPitch.new(pitch) }
  let(:pitch) { create(:pitch, :for_workshop) }

  it 'uses the correct subclass' do
    converter = double
    expect(converter).to receive(:call).and_return(true)
    expect(ConvertPitch::StandaloneWorkshop)
      .to receive(:new)
      .with(pitch)
      .and_return(converter)
    service.call
  end
end
