require 'rails_helper'

describe Measure do
  before { create(:measure) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:api_name) }
  it { is_expected.to validate_uniqueness_of(:api_name) }
end
