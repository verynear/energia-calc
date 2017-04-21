require 'rails_helper'

describe StructureTypeSubtypesPresenter do
  let(:structure_type) { instance_double(StructureType) }

  describe '#as_json' do
    context 'for primary types' do
      it 'returns only the one primary structure type' do
        structure_type = create(:structure_type, primary: true)
        presenter = described_class.new(structure_type)
        expect(presenter.as_json).to eq({
          types: [[structure_type.name, structure_type.id]],
          subtypes: []
        })
      end
    end

    context 'for structure types with only child types' do
      it 'returns all child types' do
        dhw_type = create(:structure_type,
                          name: 'Domestic Hot Water System',
                          primary: false)
        indirect_type = create(:structure_type,
                               name: 'Boiler/Tank - Indirect Fired',
                               parent_structure_type: dhw_type)
        direct_type = create(:structure_type,
                             name: 'Direct Fired',
                             parent_structure_type: dhw_type)
        presenter = described_class.new(dhw_type)
        expect(presenter.as_json).to eq({
          types: [
            ['Boiler/Tank - Indirect Fired', indirect_type.id],
            ['Direct Fired', direct_type.id]
          ],
          subtypes: []
        })
      end
    end

    context 'for structure types that have child types and subtypes' do
      let!(:heating_system_type) do
        create(:structure_type,
               name: 'Heating System',
               primary: false)
      end
      let!(:controls_type) do
        create(:structure_type,
               name: 'Controls',
               parent_structure_type: heating_system_type,
               primary: true)
      end
      let!(:forced_air_type) do
        create(:structure_type,
               name: 'Forced Air',
               parent_structure_type: heating_system_type,
               primary: true)
      end

      it 'returns all child types and subtypes' do
        outdoor_cutoff_type = create(:structure_type,
                                     name: 'Outdoor Cutoff',
                                     parent_structure_type: controls_type,
                                     primary: true)
        presenter = described_class.new(heating_system_type)
        expect(presenter.as_json).to eq({
          types: [
            ['Controls', controls_type.id],
            ['Forced Air', forced_air_type.id]
          ],
          subtypes: [
            ['Outdoor Cutoff', outdoor_cutoff_type.id]
          ]
        })
      end

      it 'returns subtypes for the selected type' do
        electric_subtype = create(:structure_type,
                                  name: 'Electric',
                                  parent_structure_type: forced_air_type,
                                  primary: true)
        presenter = described_class.new(heating_system_type, forced_air_type.id)
        expect(presenter.as_json).to eq({
          types: [
            ['Controls', controls_type.id],
            ['Forced Air', forced_air_type.id]
          ],
          subtypes: [
            ['Electric', electric_subtype.id]
          ]
        })
      end
    end
  end
end
