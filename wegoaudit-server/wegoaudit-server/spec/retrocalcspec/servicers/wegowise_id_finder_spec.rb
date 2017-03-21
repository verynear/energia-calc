require 'rails_helper'

describe WegowiseIdFinder do
  describe '#find_ids' do
    let(:wegowise_ids) do
      { 'building' => { ids: [123] },
        'apartment' => { ids: [456] },
        'meter' => { ids: [789] } }
    end

    it 'finds ids of physical structures that are not nested' do
      structures = [
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'bar',
          'structure_type' => {
            'name' => 'Building',
            'api_name' => 'building' },
          'wegowise_id' => 123,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'baz',
          'structure_type' => {
            'name' => 'Apartment',
            'api_name' => 'apartment' },
          'wegowise_id' => 456,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'qux',
          'structure_type' => {
            'name' => 'Meter',
            'api_name' => 'meter' },
          'wegowise_id' => 789,
          'fields' => {},
          'substructures' => []
        }
      ]
      finder = described_class.new(structures)

      expect(finder.find_ids).to eq(wegowise_ids)
    end

    it 'finds ids of physical structures that are nested' do
      structures = [
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'bar',
          'structure_type' => {
            'name' => 'Building',
            'api_name' => 'building' },
          'wegowise_id' => 123,
          'fields' => {},
          'substructures' => [
            {
              'id' => SecureRandom.uuid,
              'name' => 'baz',
              'structure_type' => {
                'name' => 'Apartment',
                'api_name' => 'apartment' },
              'wegowise_id' => 456,
              'fields' => {},
              'substructures' => [
                {
                  'id' => SecureRandom.uuid,
                  'name' => 'qux',
                  'structure_type' => {
                    'name' => 'Meter',
                    'api_name' => 'meter' },
                  'wegowise_id' => 789,
                  'fields' => {},
                  'substructures' => []
                }
              ]
            }
          ]
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo2',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        }
      ]
      finder = described_class.new(structures)

      expect(finder.find_ids).to eq(wegowise_ids)
    end
  end

  describe '#find_ids_and_names' do
    let(:ids_and_names) do
      { 'building' => { ids: [123], names: ['bar'] },
        'apartment' => { ids: [456], names: ['baz'] },
        'meter' => { ids: [789], names: ['qux'] } }
    end

    it 'finds ids and names of physical structures that are not nested' do
      structures = [
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'bar',
          'structure_type' => {
            'name' => 'Building',
            'api_name' => 'building' },
          'wegowise_id' => 123,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'baz',
          'structure_type' => {
            'name' => 'Apartment',
            'api_name' => 'apartment' },
          'wegowise_id' => 456,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'qux',
          'structure_type' => {
            'name' => 'Meter',
            'api_name' => 'meter' },
          'wegowise_id' => 789,
          'fields' => {},
          'substructures' => []
        }
      ]
      finder = described_class.new(structures)

      expect(finder.find_ids_and_names).to eq(ids_and_names)
    end

    it 'finds ids and names of physical structures that are nested' do
      structures = [
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'bar',
          'structure_type' => {
            'name' => 'Building',
            'api_name' => 'building' },
          'wegowise_id' => 123,
          'fields' => {},
          'substructures' => [
            {
              'id' => SecureRandom.uuid,
              'name' => 'baz',
              'structure_type' => {
                'name' => 'Apartment',
                'api_name' => 'apartment' },
              'wegowise_id' => 456,
              'fields' => {},
              'substructures' => [
                {
                  'id' => SecureRandom.uuid,
                  'name' => 'qux',
                  'structure_type' => {
                    'name' => 'Meter',
                    'api_name' => 'meter' },
                  'wegowise_id' => 789,
                  'fields' => {},
                  'substructures' => []
                }
              ]
            }
          ]
        },
        {
          'id' => SecureRandom.uuid,
          'name' => 'foo2',
          'structure_type' => {
            'name' => 'Other',
            'api_name' => 'other' },
          'wegowise_id' => nil,
          'fields' => {},
          'substructures' => []
        }
      ]
      finder = described_class.new(structures)

      expect(finder.find_ids_and_names).to eq(ids_and_names)
    end
  end
end
