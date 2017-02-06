require 'rails_helper'

describe Retrocalc::AuditsController do
  describe '#index' do
    let(:user) { mock_model(User, active_audits: []) }
    let(:audit1) do
      mock_model(
        Audit,
        audit_type: double(name: 'audit type 1'),
        name: 'first audit',
        performed_on: '2015-04-03 12:50')
    end

    let(:audit2) do
      mock_model(
        Audit,
        audit_type: double(name: 'audit type 2'),
        name: 'second audit',
        performed_on: '2015-04-04 14:50')
    end

    it 'responds with a success status code if user is found' do
      expect(User).to receive(:find_by).with(wegowise_id: '3')
        .and_return(user)

      get :index, wegowise_id: 3
      expect(response.status).to eq(200)
    end

    it 'responds with an error status code if wegowise id not provided' do
      get :index
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'missing_wegowise_id',
          'message' => 'wegowise_id is a required parameter')
    end

    it 'responds with an error status code if user is not found' do
      expect(User).to receive(:find_by).with(wegowise_id: '3')
        .and_return(nil)

      get :index, wegowise_id: 3
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'user_not_found',
          'message' => 'Unable to find wegowise id 3')
    end

    it 'returns an empty list for a user with no audits' do
      expect(User).to receive(:find_by).with(wegowise_id: '3')
        .and_return(user)

      get :index, wegowise_id: 3
      expect(JSON.parse(response.body)['audits']).to eq([])
    end

    it 'returns a list of audits' do
      allow(user).to receive(:active_audits).and_return([audit1, audit2])
      expect(User).to receive(:find_by).with(wegowise_id: '3')
        .and_return(user)

      get :index, wegowise_id: 3
      expect(JSON.parse(response.body)['audits'])
        .to eq([{'id' => audit1.id,
                 'name' => 'first audit',
                 'date' => '2015-04-03 12:50',
                 'audit_type' => 'audit type 1'
                },
                {'id' => audit2.id,
                 'name' => 'second audit',
                 'date' => '2015-04-04 14:50',
                 'audit_type' => 'audit type 2'
                }])
    end
  end

  describe '#show' do
    let!(:user) { create(:user, wegowise_id: 3) }
    let!(:audit_type) { create(:audit_type, name: 'Investigatin') }
    let!(:audit) do
      create(:audit,
             name: 'an audit',
             user: user,
             performed_on: '2015-04-04 14:50',
             audit_type: audit_type)
    end

    it 'responds with an error status code if wegowise id not provided' do
      get :show, id: 'blah'
      expect(response.status).to eq(400)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'missing_wegowise_id',
          'message' => 'wegowise_id is a required parameter')
    end

    it 'responds with an error status code if user is not found' do
      get :index, wegowise_id: 4, id: 'blah'
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'user_not_found',
          'message' => 'Unable to find wegowise id 4')
    end

    it 'responds with an error status code if audit is not found' do
      other_audit_id = SecureRandom.uuid
      get :show, wegowise_id: 3, id: other_audit_id
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'audit_not_found',
          'message' => "Unable to find audit id #{other_audit_id}")
    end

    it 'responds with an error status code if audit belongs to another user' do
      user2 = create(:user)
      audit2 = create(:audit, user: user2)

      get :show, wegowise_id: 3, id: audit2.id
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error'])
        .to eq(
          'code' => 'audit_not_found',
          'message' => "Unable to find audit id #{audit2.id}")
    end

    it 'returns a hash for an audit with measures' do
      measure1 = create(:measure, name: 'measure 1')
      measure2 = create(:measure, name: 'measure 2')
      create(:measure_value,
             audit: audit,
             notes: 'notes1',
             measure: measure1)
      create(:measure_value,
             audit: audit,
             notes: 'notes2',
             measure: measure2)

      get :show, wegowise_id: 3, id: audit.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['audit']).to eq(
        'id' => audit.id,
        'name' => 'an audit',
        'date' => '2015-04-04T14:50:00.000Z',
        'audit_type' => 'Investigatin',
        'measures' => [
          { 'notes' => 'notes1',
            'name' => 'measure 1',
            'api_name' => 'measure_1' },
          { 'notes' => 'notes2',
            'name' => 'measure 2',
            'api_name' => 'measure_2' }],
        'photos' => [],
        'sample_groups' => [],
        'structures' => []
      )
      expect(response.body).to match_response_schema("retrocalc/audit")
    end

    it 'returns a hash for an audit with structures' do
      structure_type1 = create(:structure_type, name: 'First structure Type')
      structure_type2 = create(:structure_type, name: 'Second structure Type')
      structure1 = create(:structure,
                          name: 'foo',
                          structure_type: structure_type1,
                          parent_structure: audit.structure)
      structure1a = create(:structure,
                           name: 'bar',
                           structure_type: structure_type2,
                           parent_structure: structure1)
      field1 = create(:field, name: 'Field 1', value_type: 'integer')
      field2 = create(:field, name: 'Field 2', value_type: 'string')
      create(:field_value, value: 1, field: field1, structure: structure1)
      create(:field_value, value: 'val', field: field2, structure: structure1)
      create(:field_value, value: 3, field: field1, structure: structure1a)

      get :show, wegowise_id: 3, id: audit.id
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)['audit']).to eq(
        'id' => audit.id,
        'name' => 'an audit',
        'date' => '2015-04-04T14:50:00.000Z',
        'audit_type' => 'Investigatin',
        'measures' => [],
        'photos' => [],
        'sample_groups' => [],
        'structures' => [
          { 'id' => structure1.id,
            'name' => 'foo',
            'wegowise_id' => nil,
            'structure_type' => { 'name' => 'First structure Type',
                                  'api_name' => 'first_structure_type' },
            'field_values' => {
              'field_1' => { 'value' => 1,
                             'value_type' => 'integer',
                             'name' => 'Field 1' },
              'field_2' => { 'value' => 'val',
                             'value_type' => 'string',
                             'name' => 'Field 2' }
            },
            'n_structures' => 1,
            'sample_group_id' => nil,
            'photos' => [],
            'substructures' => [
              { 'id' => structure1a.id,
                'name' => 'bar',
                'wegowise_id' => nil,
                'structure_type' => { 'name' => 'Second structure Type',
                                      'api_name' => 'second_structure_type' },
                'field_values' => {
                  'field_1' => { 'value' => 3,
                                 'value_type' => 'integer',
                                 'name' => 'Field 1' }
                },
                'n_structures' => 1,
                'sample_group_id' => nil,
                'photos' => [],
                'substructures' => [] }
            ]
          }
        ]
      )
      expect(response.body).to match_response_schema("retrocalc/audit")
    end
  end
end
