require 'rails_helper'

describe StructureGroupingPresenter do
  let!(:audit_structure) { create(:audit_structure) }
  let!(:grouping) { create(:grouping, audit_strc_type: audit_structure.audit_strc_type) }
  let(:presenter) { described_class.new(audit_structure, grouping) }

  describe '#fields' do
    before do
      create(:audit_field, :string,
             display_order: 2,
             grouping: grouping,
             name: 'Foo field')
      create(:audit_field, :string,
             display_order: 1,
             grouping: grouping,
             name: 'Bar field')
    end

    it 'returns fields in the correct order' do
      expect(presenter.audit_fields.map(&:name)).to eq ['Bar field', 'Foo field']
    end

    it 'maps each field to an instance of StructureFieldPresenter' do
      expect(presenter.audit_fields.map(&:class).uniq).to eq [StructureFieldPresenter]
    end

    it 'maps field_values onto their corresponding field' do
      audit_field = AuditField.find_by(name: 'Foo field')
      create(:audit_field_value,
             audit_field: audit_field,
             string_value: 'My string field value',
             audit_structure: audit_structure)
      expect(presenter.audit_fields.map(&:value)).to eq [nil, 'My string field value']
    end
  end
end
