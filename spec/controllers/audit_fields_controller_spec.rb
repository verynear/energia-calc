require 'rails_helper'

describe AuditFieldsController do
  describe '#index' do
    let!(:field1) do
      create(:audit_field, name: 'first field', value_type: 'integer')
    end
    let!(:field2) do
      create(:audit_field, name: 'second field', value_type: 'picker')
    end
    let!(:enumeration1) do
      create(:field_enumeration,
             audit_field: field2,
             value: 'option1',
             display_order: 1)
    end
    let!(:enumeration2) do
      create(:field_enumeration,
             audit_field: field2,
             value: 'option2',
             display_order: 2)
    end

    it 'responds with a success status code without wegowise_id set' do
      get :index
      expect(response.status).to eq(200)
    end

    it 'returns a list of available fields' do
      expect(AuditField).to receive(:uniq)
        .and_return(double(order: [field1, field2]))

      get :index, wegowise_id: 3
      expect(JSON.parse(response.body)['audit_fields'])
        .to eq([{'name' => 'first field',
                 'api_name' => 'first_field',
                 'value_type' => 'integer',
                 'options' => []
                },
                {'name' => 'second field',
                 'api_name' => 'second_field',
                 'value_type' => 'picker',
                 'options' => %w[option1 option2]
                }])
    end
  end
end
