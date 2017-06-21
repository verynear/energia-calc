require 'rails_helper'

describe Field do
  before { create(:field) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:api_name) }
  it { is_expected.to validate_uniqueness_of(:api_name) }
  it { is_expected.to validate_presence_of(:value_type) }
end
