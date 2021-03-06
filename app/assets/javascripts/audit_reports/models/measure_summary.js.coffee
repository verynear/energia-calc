class AuditReports.Models.MeasureSummary extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'field_values',
    relatedModel: 'AuditReports.Models.FieldValue',
    reverseRelation: {
      key: 'measure_summary'
    }
  }]

  defaults:
    id: ''
    measure_fields: []
    results: []

  initialize: ->
    AuditReports.EventBus.on(
      "channel:measure_summary:#{@get('id')}",
      @_listenToChannel
    )

  _listenToChannel: (args) =>
    [event, data] = args
    @set(data) if event == 'change'

AuditReports.Models.MeasureSummary.setup()
