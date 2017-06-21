require 'rails_helper'

describe StructureDetailsPresenter do
  let!(:audit_structure) { create(:audit_structure) }
  let(:presenter) { described_class.new(audit_structure) }

  before do
    create(:grouping,
           display_order: 2,
           name: 'Foo group',
           audit_strc_type: audit_structure.audit_strc_type)
    create(:grouping,
           display_order: 1,
           name: 'Bar group',
           audit_strc_type: audit_structure.audit_strc_type)
  end

  it 'returns all associated groupings for a structure in the correct order' do
    expect(presenter.groupings.map(&:name)).to eq ['Bar group', 'Foo group']
  end

  it 'maps the groupings to StructureGroupingPresenter objects' do
    expect(presenter.groupings.map(&:class).uniq).to eq [StructureGroupingPresenter]
  end
end
