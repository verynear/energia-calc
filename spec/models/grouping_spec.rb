require 'rails_helper'

describe Grouping do
  it { should belong_to(:structure_type) }
  it { should validate_presence_of :structure_type }
  it { should validate_presence_of :name }
  it { should validate_presence_of :display_order }
end
