require 'rails_helper'

describe StructureType do
  before { create(:structure_type) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:api_name) }
  it { is_expected.to validate_uniqueness_of(:api_name) }
end
