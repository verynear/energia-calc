require 'rails_helper'

describe StructureDestroyer do
  let!(:audit_type) { create(:audit, name: 'Audit') }
  let!(:parent_structure) do
    create(:audit_structure, name: 'Audit 1',
                       audit_strc_type_id: audit_type.id)
  end
  let!(:audit_strc_type) do
    create(:audit_strc_type, name: 'Building',
                            physical_structure_type: 'Building')
  end
  let!(:audit_structure) do
    create(:audit_structure, name: 'Building',
                       audit_strc_type_id: audit_strc_type.id,
                       parent_structure_id: parent_structure.id)
  end
  let!(:params) do
    { params: { name: '10 Main St' },
                audit_structure: audit_structure }
  end

  describe '#execute' do
    it 'destroys field values' do
      audit_field = create(:audit_field, name: 'Name')
      audit_field_value = AuditFieldValue.create(audit_field_id: audit_field.id,
                                      audit_structure_id: audit_structure.id,
                                      string_value: 'foo')
      service = StructureDestroyer.new(audit_structure: audit_structure)
      expect { service.execute }
        .to change { AuditFieldValue.count }.by(-1)
    end

    it 'destroys any sample groups' do
      sample_group = create(:sample_group, parent_structure: audit_structure)
      service = StructureDestroyer.new(audit_structure: audit_structure)
      expect { service.execute }
        .to change { SampleGroup.count }
        .from(1)
        .to(0)
    end

    it 'destroys any substructures' do
      substructure1 = create(:audit_structure, name: 'apt 1',
        parent_structure_id: audit_structure.id)
      substructure2 = create(:audit_structure, name: 'apt 2',
        parent_structure_id: audit_structure.id)
      audit_field = create(:audit_field, name: 'Name')
      audit_field_value = AuditFieldValue.new(audit_field_id: audit_field.id,
                                   audit_structure_id: substructure2.id,
                                   string_value: 'foo')

      service = StructureDestroyer.new(audit_structure: audit_structure)

      expect { service.execute }.to change { AuditStructure.count }.by(-3)
    end

    it 'destroys the structure' do
      expect { StructureDestroyer.execute!(audit_structure: audit_structure) }
        .to change { AuditStructure.count }.by(-1)
    end

    it 'destroys the physical_structure' do
      building = create(:building_with_structure, nickname: '121 Farnsworth Rd')
      audit_structure.physical_structure = building
      expect { StructureDestroyer.execute!(audit_structure: audit_structure) }
        .to change { Building.count }.by(-1)
    end

    it 'destroys any images' do
      image = create(:structure_image, audit_structure_id: audit_structure.id)

      expect { StructureDestroyer.execute!(audit_structure: audit_structure) }
        .to change { StructureImage.count }.by(-1)
    end
  end
end
