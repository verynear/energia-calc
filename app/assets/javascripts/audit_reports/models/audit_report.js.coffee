class AuditReports.Models.AuditReport extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'measure_selections',
    relatedModel: 'AuditReports.Models.MeasureSelection',
    collectionType: 'AuditReports.Collections.MeasureSelections',
    reverseRelation: {
      key: 'audit_report'
    }
  },
  {
    type: Backbone.HasMany,
    key: 'field_values',
    relatedModel: 'AuditReports.Models.FieldValue',
    reverseRelation: {
      key: 'audit_report'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'audit_report_summary',
    relatedModel: 'AuditReports.Models.AuditReportSummary',
    reverseRelation: Backbone.HasOne
  },
  {
    type: Backbone.HasOne,
    key: 'audit_report_name_field_value',
    relatedModel: 'AuditReports.Models.AuditReportNameFieldValue',
    reverseRelation: {
      key: 'structure'
    }
  }

  ]

