class AuditReports.Views.AuditReportField extends AuditReports.Views.Field
  className: 'col-3'
  inputClass: "js-measure-selection-field"

  syncUrl: ->
    "/audit_reports/#{@model.get('audit_report').get('id')}/" +
      "field_values/#{@model.get('id')}"
