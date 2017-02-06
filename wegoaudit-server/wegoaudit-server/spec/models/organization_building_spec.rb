require 'rails_helper'

describe OrganizationBuilding do
  it { should belong_to :building }
  it { should belong_to :organization }
  it { should validate_presence_of :building }
  it { should validate_presence_of :organization }
end
