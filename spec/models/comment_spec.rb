# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Comment, type: :model do
  subject(:comment) { build(:comment) }

  it { is_expected.to be_valid }
  it { is_expected.to validate_presence_of(:text) }
end
