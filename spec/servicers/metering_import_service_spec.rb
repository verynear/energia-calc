require 'rails_helper'

describe MeteringImportService do
  let!(:organization) { create(:organization) }
  let!(:meter) { create(:water_meter) }
  let!(:service) do
    MeteringImportService.new(params: params,
                              meter: meter,
                              user: organization.owner)
  end

  describe 'if the physical structure exists' do
    let(:building) { create(:building_with_structure, cloned: false) }

    it 'creates a structure with association to the building if one does not
        exist' do
      before_count = AuditStructure.count
      service.execute
      expect(AuditStructure.count).to eq before_count + 1
      expect(building.audit_structure.substructures.first.physical_structure)
        .to eq meter
    end

    it 'does not create a structure if one already exists' do
      AuditStructure.create(audit_strc_type: Meter.audit_strc_type,
                       physical_structure: meter,
                       parent_structure_id: building.audit_structure,
                       name: meter.name)
      expect { service.execute }.to change { AuditStructure.count }.by 0
    end
  end

  describe 'if the structure does not exist' do
    let(:building) { double(wegowise_id: 1) }

    it 'creates a temporary structure' do
      expect { service.execute }.to change { Building.count }.by 1
    end

    it 'creates a structure for the meter and the temporary physical structure' do
      expect { service.execute }.to change { AuditStructure.count }.by 2
    end

    it 'enqueues the structure retrieval' do
      expect(BuildingRetrievalWorker)
        .to receive(:perform_async).with(1,
                                         organization.owner.id)
      service.execute!
    end
  end

  def params
    { name: "Better Housing Old",
      id: building.wegowise_id,
      sqft: 8480,
      type: "Building" }
  end
end
