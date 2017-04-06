class AuditReports.Views.OriginalStructureField extends AuditReports.Views.Field
  syncUrl: ->
    "/calc/audit_reports/#{@model.get('audit_report_id')}/" +
      "original_structure_field_values/#{@model.get('real_id')}"

  title: ->
    "Pre-report #{@model.get('name')}"

  initialize: (options) ->
    @listenTo(@model, 'change:value', @render)

  _afterSyncFieldValue: (data) =>
    super(data)
    AuditReports.EventBus.trigger(
      "channel:original_structure_field_value:#{@model.get('real_id')}",
      ['change', data.new_value]
    )
