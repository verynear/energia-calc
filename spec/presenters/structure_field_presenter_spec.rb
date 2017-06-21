require 'rails_helper'

describe StructureFieldPresenter do
  let(:audit_structure) { instance_double(AuditStructure) }

  describe '#partial' do
    it 'returns the corresponding partial name for field types' do
      audit_field = instance_double(AuditField, value_type: 'switch')
      presenter = described_class.new(audit_structure, audit_field)
      expect(presenter.partial).to eq 'checkbox_field'
    end

    it 'returns text_input for unknown field types' do
      audit_field = instance_double(AuditField, value_type: 'spam')
      presenter = described_class.new(audit_structure, audit_field)
      expect(presenter.partial).to eq 'text_input_field'
    end
  end

  describe '#value' do
    let(:audit_field) { instance_double(AuditField) }

    it 'returns nil if field_value is not nil' do
      presenter = described_class.new(audit_structure, audit_field)
      expect(presenter.audit_field_value).to eq nil
    end

    it 'returns the field_value if it has one' do
      audit_field_value = instance_double(AuditFieldValue, value: :foo)
      presenter = described_class.new(audit_structure, audit_field, audit_field_value)
      expect(presenter.audit_field_value).to eq :foo
    end
  end
end
