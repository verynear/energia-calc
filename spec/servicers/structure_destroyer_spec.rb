require 'rails_helper'

describe StructureDestroyer do
  let!(:audit_type) { create(:audit, name: 'Audit') }
  let!(:parent_structure) do
    create(:structure, name: 'Audit 1',
                       structure_type_id: audit_type.id)
  end
  let!(:structure_type) do
    create(:structure_type, name: 'Building',
                            physical_structure_type: 'Building')
  end
  let!(:structure) do
    create(:structure, name: 'Building',
                       structure_type_id: structure_type.id,
                       parent_structure_id: parent_structure.id)
  end
  let!(:params) do
    { params: { name: '10 Main St' },
                structure: structure }
  end

  describe '#execute' do
    it 'destroys field values' do
      field = create(:field, name: 'Name')
      field_value = FieldValue.create(field_id: field.id,
                                      structure_id: structure.id,
                                      string_value: 'foo')
      service = StructureDestroyer.new(structure: structure)
      expect { service.execute }
        .to change { FieldValue.count }.by(-1)
    end

    it 'destroys any sample groups' do
      sample_group = create(:sample_group, parent_structure: structure)
      service = StructureDestroyer.new(structure: structure)
      expect { service.execute }
        .to change { SampleGroup.count }
        .from(1)
        .to(0)
    end

    it 'destroys any substructures' do
      substructure1 = create(:structure, name: 'apt 1',
        parent_structure_id: structure.id)
      substructure2 = create(:structure, name: 'apt 2',
        parent_structure_id: structure.id)
      field = create(:field, name: 'Name')
      field_value = FieldValue.new(field_id: field.id,
                                   structure_id: substructure2.id,
                                   string_value: 'foo')

      service = StructureDestroyer.new(structure: structure)

      expect { service.execute }.to change { Structure.count }.by(-3)
    end

    it 'destroys the structure' do
      expect { StructureDestroyer.execute!(structure: structure) }
        .to change { Structure.count }.by(-1)
    end

    it 'destroys the physical_structure' do
      building = create(:building_with_structure, nickname: '121 Farnsworth Rd')
      structure.physical_structure = building
      expect { StructureDestroyer.execute!(structure: structure) }
        .to change { Building.count }.by(-1)
    end

    it 'destroys any images' do
      image = create(:structure_image, structure_id: structure.id)

      expect { StructureDestroyer.execute!(structure: structure) }
        .to change { StructureImage.count }.by(-1)
    end
  end
end
