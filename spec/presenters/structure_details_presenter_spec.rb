require 'rails_helper'

describe StructureDetailsPresenter do
  let!(:structure) { create(:structure) }
  let(:presenter) { described_class.new(structure) }

  before do
    create(:grouping,
           display_order: 2,
           name: 'Foo group',
           structure_type: structure.structure_type)
    create(:grouping,
           display_order: 1,
           name: 'Bar group',
           structure_type: structure.structure_type)
  end

  it 'returns all associated groupings for a structure in the correct order' do
    expect(presenter.groupings.map(&:name)).to eq ['Bar group', 'Foo group']
  end

  it 'maps the groupings to StructureGroupingPresenter objects' do
    expect(presenter.groupings.map(&:class).uniq).to eq [StructureGroupingPresenter]
  end
end
