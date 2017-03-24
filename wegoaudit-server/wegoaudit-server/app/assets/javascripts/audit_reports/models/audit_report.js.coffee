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
    key: 'calc_field_values',
    relatedModel: 'AuditReports.Models.CalcFieldValue',
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
    key: 'audit_report_name_calc_field_value',
    relatedModel: 'AuditReports.Models.AuditReportNameCalcFieldValue',
    reverseRelation: {
      key: 'calc_structure'
    }
  }

  ]

