require 'rails_helper'

describe Organization do
  it { should validate_presence_of :name }
  it { should validate_presence_of :owner }

  it { should have_many :buildings }
  it { should have_many :organization_buildings }
  it { should have_many :users }
end
