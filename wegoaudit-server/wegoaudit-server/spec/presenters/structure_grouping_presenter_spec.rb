require 'rails_helper'

describe StructureGroupingPresenter do
  let!(:structure) { create(:structure) }
  let!(:grouping) { create(:grouping, structure_type: structure.structure_type) }
  let(:presenter) { described_class.new(structure, grouping) }

  describe '#fields' do
    before do
      create(:field, :string,
             display_order: 2,
             grouping: grouping,
             name: 'Foo field')
      create(:field, :string,
             display_order: 1,
             grouping: grouping,
             name: 'Bar field')
    end

    it 'returns fields in the correct order' do
      expect(presenter.fields.map(&:name)).to eq ['Bar field', 'Foo field']
    end

    it 'maps each field to an instance of StructureFieldPresenter' do
      expect(presenter.fields.map(&:class).uniq).to eq [StructureFieldPresenter]
    end

    it 'maps field_values onto their corresponding field' do
      field = Field.find_by(name: 'Foo field')
      create(:field_value,
             field: field,
             string_value: 'My string field value',
             structure: structure)
      expect(presenter.fields.map(&:value)).to eq [nil, 'My string field value']
    end
  end
end
