require 'rails_helper'

describe AuditDestroyer do
  let(:audit_type) { create(:audit, name: 'Audit') }
  let(:audit_structure) do
    create(:audit_structure, name: 'Audit 1',
                       audit_strc_type_id: audit_type.id)
  end
  let!(:audit) { create(:audit, audit_structure: audit_structure) }
  let!(:audit_measure) { create(:audit_measure) }
  let!(:audit_measure_value) do
    create(:audit_measure_value, audit_measure: audit_measure, audit: audit)
  end
  describe 'execute' do
    it 'destroys the structure' do
      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { AuditStructure.count }.by(-1)
    end

    it 'destroys measure_values' do
      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { AuditMeasureValue.count }.by(-1)
    end

    it 'destroys the audit' do
      image = create(:structure_image, audit_structure_id: audit_structure.id)

      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { Audit.count }.by(-1)
    end
  end
end
