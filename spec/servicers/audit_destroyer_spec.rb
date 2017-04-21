require 'rails_helper'

describe AuditDestroyer do
  let(:audit_type) { create(:audit, name: 'Audit') }
  let(:structure) do
    create(:structure, name: 'Audit 1',
                       structure_type_id: audit_type.id)
  end
  let!(:audit) { create(:audit, structure: structure) }
  let!(:measure) { create(:measure) }
  let!(:measure_value) do
    create(:measure_value, measure: measure, audit: audit)
  end
  describe 'execute' do
    it 'destroys the structure' do
      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { Structure.count }.by(-1)
    end

    it 'destroys measure_values' do
      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { MeasureValue.count }.by(-1)
    end

    it 'destroys the audit' do
      image = create(:structure_image, structure_id: structure.id)

      expect { AuditDestroyer.execute!(audit: audit) }
        .to change { Audit.count }.by(-1)
    end
  end
end
