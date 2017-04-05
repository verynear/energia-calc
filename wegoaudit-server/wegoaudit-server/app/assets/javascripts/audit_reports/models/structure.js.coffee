class AuditReports.Models.Structure extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'field_values',
    relatedModel: 'AuditReports.Models.FieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  },
  {
    type: Backbone.HasMany,
    key: 'original_structure_field_values',
    relatedModel: 'AuditReports.Models.OriginalStructureFieldValue',
    reverseRelation: {
      key: 'structure'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'name_field_value',
    relatedModel: 'AuditReports.Models.NameFieldValue',
    reverseRelation: {
      key: 'structure'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'quantity_field_value',
    relatedModel: 'AuditReports.Models.QuantityFieldValue',
    reverseRelation: {
      key: 'structure'
    }
  }
  ]

  defaults:
    name: ''
    field_values: []

AuditReports.Models.Structure.setup()
