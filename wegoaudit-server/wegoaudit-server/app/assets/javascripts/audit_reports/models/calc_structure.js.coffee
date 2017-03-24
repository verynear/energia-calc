class AuditReports.Models.CalcStructure extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'calc_field_values',
    relatedModel: 'AuditReports.Models.CalcFieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  },
  {
    type: Backbone.HasMany,
    key: 'original_structure_field_values',
    relatedModel: 'AuditReports.Models.OriginalStructureFieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'name_calc_field_value',
    relatedModel: 'AuditReports.Models.NameCalcFieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'quantity_calc_field_value',
    relatedModel: 'AuditReports.Models.QuantityCalcFieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  }
  ]

  defaults:
    name: ''
    field_values: []

AuditReports.Models.CalcStructure.setup()
