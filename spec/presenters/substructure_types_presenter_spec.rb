require 'rails_helper'

describe SubstructureTypesPresenter do
  let!(:audit) { create(:audit) }
  let!(:audit_audit_strc_type) { audit.audit_structure.audit_strc_type }
  let!(:building_type) do
    create(:building_audit_strc_type,
           display_order: 1,
           parent_structure_type: audit_audit_strc_type)
  end
  let(:presenter) { described_class.new(audit.audit_structure) }

  describe '#substructures' do
    it 'orders structures by name' do
      building1 = create(:audit_structure,
                         name: 'Building 1',
                         parent_structure: audit.audit_structure,
                         audit_strc_type: building_type)
      building2 = create(:audit_structure,
                         name: 'Building 2',
                         parent_structure: audit.audit_structure,
                         audit_strc_type: building_type)

      expect(presenter.substructures).to eq({
        building_type => [building1, building2]
      })
    end

    it 'groups structures by type' do
      heating_system_type = create(:audit_strc_type,
                                   display_order: 2,
                                   name: 'Heating System',
                                   parent_structure_type: audit_audit_strc_type)
      heating_system = create(:audit_structure,
                              parent_structure: audit.audit_structure,
                              audit_strc_type: heating_system_type)

      expect(presenter.substructures).to eq({
        building_type => [],
        heating_system_type => [heating_system]
      })
    end

    it 'returns both structures and sample group decendents' do
      apartment_type = create(:audit_strc_type,
                              name: 'Apartment',
                              parent_structure_type: audit_audit_strc_type)
      apartment = create(:sample_group,
                         parent_structure: audit.audit_structure,
                         audit_strc_type: apartment_type)
      building = create(:audit_structure,
                        parent_structure: audit.audit_structure,
                        audit_strc_type: building_type)


      expect(presenter.substructures).to eq({
        apartment_type => [apartment],
        building_type => [building]
      })
    end
  end
end
