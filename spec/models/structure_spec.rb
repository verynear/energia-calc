require 'rails_helper'

describe Structure do
  let!(:structure) { create(:structure) }

  it { is_expected.to belong_to(:structure_change) }
  it { is_expected.to have_many(:field_values) }
  it do
    is_expected.to delegate_method(:wegoaudit_structure).to(:structure_change)
  end
end
