class AuditReports.Models.AuditReportSummary extends Backbone.RelationalModel
  relations: [{
    type: Backbone.HasMany,
    key: 'measure_summaries',
    relatedModel: 'AuditReports.Models.MeasureSummary',
    reverseRelation: {
      key: 'measure_summary'
    }
  }]

  defaults:
    id: ''
    annual_cost_savings: null
    annual_energy_savings: null
    annual_water_savings: null
    years_to_payback: null
    cost_of_measure: null
    utility_rebate: null

  initialize: ->
    AuditReports.EventBus.on(
      "channel:audit_report_summary:#{@get('id')}",
      @_listenToChannel
    )

  _listenToChannel: (args) =>
    [event, data] = args
    @set(data) if event == 'change'

AuditReports.Models.AuditReportSummary.setup()
