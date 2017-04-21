class AuditReports.Models.MeasureSelection extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'structure_changes',
    relatedModel: 'AuditReports.Models.StructureChange',
    reverseRelation: {
      key: 'measure_selection'
    }
  },
  {
    type: Backbone.HasMany,
    key: 'photos',
    relatedModel: 'AuditReports.Models.MeasurePhoto',
    collectionType: 'AuditReports.Collections.MeasurePhotos',
    reverseRelation: {
      key: 'measure_selection'
    }
  },
  {
    type: Backbone.HasOne,
    key: 'measure_summary',
    relatedModel: 'AuditReports.Models.MeasureSummary',
    reverseRelation: Backbone.HasOne
  }]

  defaults:
    active: false
    calculate_order: ''
    enabled: true
    id: ''
    name: ''
    notes: ''
    photos: []
    report_id: ''
    selected_photo_id: ''
    structure_changes: []

  toggleEnabled: ->
    @set(enabled: !@get('enabled'))

AuditReports.Models.MeasureSelection.setup()
