require 'rails_helper'

describe SubstructureType do
  it { should belong_to :structure_type }
  it { should belong_to :parent_structure_type }
end
