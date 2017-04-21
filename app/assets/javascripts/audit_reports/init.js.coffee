window.AuditReports =
  Views: {}
  Models: {}
  EventBus: _.extend({}, Backbone.Events)
  Collections: {}
  generate: (params) -> new AuditReports.Generator(params)

window.triggerAuditReportSummary =
  (data) ->
    AuditReports.EventBus.trigger(
      "channel:effective_structure_field_values",
      ['change', data.audit_report_summary.effective_structure_values_lookup]
    )
    AuditReports.EventBus.trigger(
      "channel:audit_report_summary:#{data.audit_report_summary.id}",
              ['change', data.audit_report_summary]
    )
