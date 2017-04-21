require 'rails_helper'

describe Retrocalc::StructureTypesController do
  describe '#index' do
    let!(:audit_structure_type) do
      create(:structure_type,
             name: 'Audit',
             api_name: 'audit',
             primary: false)
    end
    let!(:structure_type1) do
      create(:structure_type,
             name: 'first structure_type',
             parent_structure_type: audit_structure_type,
             primary: true)
    end
    let!(:structure_type2) do
      create(:structure_type,
             name: 'second structure_type',
             parent_structure_type: structure_type1,
             primary: true)
    end

    it 'responds with a success status code without wegowise_id set' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'returns a list of available structure_types' do
      expect(StructureType).to receive(:uniq)
        .and_return(double(order: [structure_type1, structure_type2]))

      get :index, wegowise_id: 3
      expect(JSON.parse(response.body)['structure_types'])
        .to eq([{'name' => 'first structure_type',
                 'api_name' => 'first_structure_type',
                 'genus_api_name' => 'audit',
                 'parent_api_name' => 'audit'
                },
                {'name' => 'second structure_type',
                 'api_name' => 'second_structure_type',
                 'genus_api_name' => 'audit',
                 'parent_api_name' => 'first_structure_type'
                }])
    end
  end
end
