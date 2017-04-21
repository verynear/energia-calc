class AuditReports.Models.StructureChange extends Backbone.RelationalModel
  defaults:
    original_structure: null
    proposed_structure: null

  relations: [{
    type: Backbone.HasOne
    key: 'original_structure'
    relatedModel: 'AuditReports.Models.Structure'
    reverseRelation: {
      key: 'structure_change'
    }
    reverseRelation: Backbone.HasOne
  },
  {
    type: Backbone.HasOne,
    key: 'proposed_structure'
    relatedModel: 'AuditReports.Models.Structure'
    reverseRelation: {
      key: 'structure_change'
    }
  }]


AuditReports.Models.StructureChange.setup()
