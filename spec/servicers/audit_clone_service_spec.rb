require 'rails_helper'

describe AuditCloneService do
  it 'gets and sets the audit' do
    service = described_class.new(audit: :foo)
    expect(service.audit).to eq :foo
  end

  it 'gets and sets the params' do
    service = described_class.new(params: :foo)
    expect(service.params).to eq :foo
  end

  it 'gets and sets the source_audit' do
    service = described_class.new(source_audit: :foo)
    expect(service.source_audit).to eq :foo
  end

  describe '#execute!' do
    let!(:foo_audit_type) { create(:audit_type, name: 'Foo Type') }
    let!(:existing_audit) do
      create(:audit,
             audit_type: foo_audit_type,
             name: 'Foo audit')
    end
    let(:params) do
      {
        name: 'Bar audit',
        performed_on: Date.new(2015, 10, 21)
      }
    end
    let(:service) do
      described_class.new(
        params: params,
        source_audit: existing_audit
      )
    end

    it 'creates a new audit with the same audit type' do
      service.execute!
      expect(service.audit.audit_type).to eq foo_audit_type
    end

    it 'sets the new name' do
      service.execute!
      expect(service.audit.name).to_not eq existing_audit.name
      expect(service.audit.name).to eq 'Bar audit'
    end

    it 'sets the new performed on date' do
      service.execute!
      expect(service.audit.performed_on).to_not eq existing_audit.performed_on
      expect(service.audit.performed_on).to eq Date.new(2015, 10, 21)
    end

    it 'creates an associated audit structure' do
      service.execute!
      expect(service.audit.structure).to be_a Structure
      expect(service.audit.structure.name).to eq 'Bar audit'
    end
  end
end
