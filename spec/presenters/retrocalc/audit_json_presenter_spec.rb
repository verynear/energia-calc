require 'rails_helper'

describe Retrocalc::AuditJsonPresenter do
  let(:audit_structure) do
    mock_model(
      AuditStructure, substructures: [], sample_groups: [], structure_images: []
    )
  end

  let(:audit) do
    mock_model(
      Audit,
      id: 'id',
      name: :name,
      performed_on: :date,
      audit_type: mock_model(AuditType, name: :audit_type),
      audit_structure: audit_structure,
      audit_measure_values: []
    )
  end

  describe '#as_json' do
    it 'returns only top level if only_top_level is true' do
      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(
        audit,
        top_level_only: true)

      expect(audit_json_presenter.as_json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type)
    end

    it 'returns the whole audit with the measures' do
      measure_value1 =
        mock_model(
          AuditMeasureValue,
          audit_measure_name: 'foo foo',
          audit_measure: double(api_name: 'foo_foo'),
          notes: 'note1')

      measure_value2 =
        mock_model(
          AuditMeasureValue,
          audit_measure_name: 'fah fah',
          audit_measure: double(api_name: 'fah_fah'))

      allow(audit).to receive(:audit_measure_values)
        .and_return([measure_value1, measure_value2])

      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(audit)
      json = audit_json_presenter.as_json
      expect(json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type,
        temp_structures: [],
        sample_groups: [],
        photos: [],
        measures: [{ name: 'foo foo', api_name: 'foo_foo', notes: 'note1' },
                   { name: 'fah fah', api_name: 'fah_fah', notes: nil }])
      expect('audit' => json).to match_response_schema("retrocalc/audit")
    end

    it 'includes photos associated with the audit structure' do
      structure_image1 = mock_model(StructureImage, id: 'foo')
      structure_image2 = mock_model(StructureImage, id: 'bar')

      allow(audit_structure).to receive(:structure_images)
        .and_return [structure_image1, structure_image2]
      allow(audit_structure).to receive(:parent_audit).and_return audit

      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(audit)
      json = audit_json_presenter.as_json

      expect(json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type,
        temp_structures: [],
        sample_groups: [],
        photos: [
          { id: 'foo',
            thumb_url: 'http://example.com/audits/id/photos/foo/thumb.jpg',
            medium_url: 'http://example.com/audits/id/photos/foo/medium.jpg' },
          { id: 'bar',
            thumb_url: 'http://example.com/audits/id/photos/bar/thumb.jpg',
            medium_url: 'http://example.com/audits/id/photos/bar/medium.jpg' }
        ],
        measures: []
      )
      expect('audit' => json).to match_response_schema("retrocalc/audit")
    end

    it 'returns the audit with the structure hierarchy' do
      field1 = double(name: 'Field 1',
                      value_type: 'integer',
                      api_name: 'field_1')
      field2 = double(name: 'Field 2',
                      value_type: 'string',
                      api_name: 'field_2')
      field3 = double(name: 'Field 3',
                      value_type: 'integer',
                      api_name: 'field_3')

      structure_image1 = mock_model(StructureImage, id: 'foo')
      structure_image2 = mock_model(StructureImage, id: 'bar')

      structure1a =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'bar',
          parent_audit: audit,
          audit_strc_type: instance_double(AuditStrcType,
                                          name: 'StructureType 1a',
                                          api_name: 'structure_type1a'),
          physical_structure: nil,
          audit_field_values: double(includes: [
            mock_model(AuditFieldValue, value: 3, audit_field: field3)]),
          substructures: [],
          structure_images: [structure_image1, structure_image2],
          sample_group: nil,
          sample_groups: [])

      structure1 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'foo',
          parent_audit: audit,
          audit_strc_type: instance_double(AuditStrcType,
                                          name: 'StructureType 1',
                                          api_name: 'structure_type1'),
          physical_structure: nil,
          audit_field_values: double(includes: [
            mock_model(AuditFieldValue, value: 1, audit_field: field1),
            mock_model(AuditFieldValue, value: 'val', audit_field: field2)
          ]),
          substructures: [structure1a],
          structure_images: [],
          sample_group: nil,
          sample_groups: [])

      allow(audit.audit_structure).to receive(:substructures)
        .and_return([structure1])

      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(audit)
      json = audit_json_presenter.as_json
      expect(json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type,
        temp_structures: [
          {
            id: structure1.id,
            name: 'foo',
            wegowise_id: nil,
            structure_type: { api_name: 'structure_type1',
                              name: 'StructureType 1' },
            audit_field_values: { 'field_1' => { value: 1,
                                     value_type: 'integer',
                                     name: 'Field 1' },
                            'field_2' => { value: 'val',
                                     value_type: 'string',
                                     name: 'Field 2' }
            },
            n_structures: 1,
            sample_group_id: nil,
            photos: [],
            substructures: [
              {
                 id: structure1a.id,
                 name: 'bar',
                 wegowise_id: nil,
                 structure_type: { api_name: 'structure_type1a',
                                   name: 'StructureType 1a' },
                audit_field_values: { 'field_3' => { value: 3,
                                         value_type: 'integer',
                                         name: 'Field 3' }
                },
                n_structures: 1,
                sample_group_id: nil,
                photos: [
                  { id: 'foo',
                    thumb_url: 'http://example.com/audits/id/photos/foo/thumb.jpg',
                    medium_url: 'http://example.com/audits/id/photos/foo/medium.jpg' },
                  { id: 'bar',
                    thumb_url: 'http://example.com/audits/id/photos/bar/thumb.jpg',
                    medium_url: 'http://example.com/audits/id/photos/bar/medium.jpg' }
                ],
                substructures: [] }
            ]
          }
        ],
        sample_groups: [],
        photos: [],
        measures: [])
      expect('audit' => json).to match_response_schema("retrocalc/audit")
    end

    it 'includes sample groups and scaled structures within sample groups' do
      substructure3 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'baz',
          physical_structure: nil,
          audit_strc_type: build(:audit_strc_type,
                                name: 'Other',
                                api_name: 'other'),
          audit_field_values: double(includes: []),
          substructures: [],
          sample_group: nil,
          sample_groups: [],
          structure_images: []
        )

      substructure2 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'bar',
          physical_structure: nil,
          audit_strc_type: build(:audit_strc_type,
                                name: 'Other',
                                api_name: 'other'),
          audit_field_values: double(includes: []),
          substructures: [substructure3],
          sample_groups: [],
          structure_images: []
        )

      sample_group =
        mock_model(
          SampleGroup,
          id: SecureRandom.uuid,
          name: 'group',
          n_structures: 5,
          substructures: [substructure2]
        )

      substructure1 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'foo',
          physical_structure: nil,
          audit_strc_type: build(:audit_strc_type,
                                name: 'Other',
                                api_name: 'other'),
          audit_field_values: double(includes: []),
          substructures: [],
          sample_group: nil,
          sample_groups: [sample_group],
          structure_images: []
        )

      allow(audit.audit_structure).to receive(:substructures)
        .and_return([substructure1])
      allow(sample_group).to receive(:parent_structure)
        .and_return(substructure1)
      allow(substructure2).to receive(:sample_group).and_return(sample_group)

      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(audit)
      json = audit_json_presenter.as_json
      expect(json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type,
        temp_structures: [
          {
            id: substructure1.id,
            name: 'foo',
            structure_type: { api_name: 'other',
                              name: 'Other' },
            wegowise_id: nil,
            field_values: {},
            n_structures: 1,
            sample_group_id: nil,
            photos: [],
            substructures: [
              {
                id: substructure2.id,
                name: 'bar',
                structure_type: { api_name: 'other',
                                  name: 'Other' },
                wegowise_id: nil,
                field_values: {},
                n_structures: 5,
                sample_group_id: sample_group.id,
                photos: [],
                substructures: [
                  {
                    id: substructure3.id,
                    name: 'baz',
                    structure_type: { api_name: 'other',
                                      name: 'Other' },
                    wegowise_id: nil,
                    field_values: {},
                    n_structures: 5,
                    sample_group_id: sample_group.id,
                    photos: [],
                    substructures: []
                  }
                ]
              }
            ]
          }
        ],
        sample_groups: [
          {
            id: sample_group.id,
            name: 'group',
            n_structures: 5,
            parent_structure_id: substructure1.id
          }
        ],
        photos: [],
        measures: [])
      expect('audit' => json).to match_response_schema("retrocalc/audit")
    end

    it 'includes wegowise id for physical structure types' do
      building1 = instance_double(Building, wegowise_id: 123)
      building2 = instance_double(Building, wegowise_id: 0)
      apartment = instance_double(Apartment, wegowise_id: 456)
      meter = instance_double(Meter, wegowise_id: 789)

      substructure1 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'foo',
          physical_structure: nil,
          audit_strc_type: build(:audit_strc_type,
                                name: 'Other',
                                api_name: 'other'),
          audit_field_values: double(includes: []),
          substructures: [],
          sample_group: nil,
          sample_groups: [],
          structure_images: []
        )

      substructure4 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'qux',
          physical_structure: meter,
          audit_strc_type: build(:meter_audit_strc_type),
          audit_field_values: double(includes: []),
          substructures: [],
          sample_group: nil,
          sample_groups: [],
          structure_images: []
        )

      substructure3 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'baz',
          physical_structure: apartment,
          audit_strc_type: build(:apartment_audit_strc_type),
          audit_field_values: double(includes: []),
          substructures: [substructure4],
          sample_group: nil,
          sample_groups: [],
          structure_images: []
        )

      substructure2 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'bar',
          physical_structure: building1,
          physical_structure_type: 'Building',
          audit_strc_type: build(:building_audit_strc_type),
          audit_field_values: double(includes: []),
          substructures: [substructure3],
          sample_group: nil,
          sample_groups: [],
          structure_images: []
        )

      substructure5 =
        mock_model(
          AuditStructure,
          id: SecureRandom.uuid,
          name: 'corge',
          physical_structure: building2,
          physical_structure_type: 'Building',
          audit_strc_type: build(:building_audit_strc_type),
          audit_field_values: double(includes: []),
          substructures: [],
          sample_group: nil,
          sample_groups: []
        )

      allow(audit.audit_structure).to receive(:substructures)
        .and_return([substructure1, substructure2, substructure5])

      audit_json_presenter = Retrocalc::AuditJsonPresenter.new(audit)
      json = audit_json_presenter.as_json
      expect(json).to eq(
        id: 'id',
        name: :name,
        date: :date,
        audit_type: :audit_type,
        temp_structures: [
          {
            id: substructure1.id,
            name: 'foo',
            structure_type: { api_name: 'other',
                              name: 'Other' },
            wegowise_id: nil,
            field_values: {},
            n_structures: 1,
            sample_group_id: nil,
            photos: [],
            substructures: []
          },
          {
            id: substructure2.id,
            name: 'bar',
            structure_type: { api_name: 'building',
                              name: 'Building' },
            wegowise_id: 123,
            field_values: {},
            n_structures: 1,
            sample_group_id: nil,
            photos: [],
            substructures: [
              {
                id: substructure3.id,
                name: 'baz',
                structure_type: { api_name: 'apartment',
                                  name: 'Apartment' },
                wegowise_id: 456,
                field_values: {},
                n_structures: 1,
                sample_group_id: nil,
                photos: [],
                substructures: [
                  {
                    id: substructure4.id,
                    name: 'qux',
                    structure_type: { api_name: 'meter',
                                      name: 'Meter' },
                    wegowise_id: 789,
                    field_values: {},
                    n_structures: 1,
                    sample_group_id: nil,
                    photos: [],
                    substructures: []
                  }
                ]
              }
            ]
          }
        ],
        sample_groups: [],
        photos: [],
        measures: [])
      expect('audit' => json).to match_response_schema("retrocalc/audit")
    end
  end
end
