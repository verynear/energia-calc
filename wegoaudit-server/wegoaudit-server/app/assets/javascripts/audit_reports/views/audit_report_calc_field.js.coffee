class AuditReports.Views.AuditReportCalcField extends AuditReports.Views.CalcField
  className: 'col-3'
  inputClass: "js-measure-selection-field"

  syncUrl: ->
    "/calc/audit_reports/#{@model.get('audit_report').get('id')}/" +
      "calc_field_values/#{@model.get('id')}"
