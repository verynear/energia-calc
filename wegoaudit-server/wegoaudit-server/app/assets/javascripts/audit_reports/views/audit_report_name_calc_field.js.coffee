class AuditReports.Views.AuditReportNameCalcField extends AuditReports.Views.CalcField
  className: 'col-3'

  inputClass: "js-audit-report-name-calc-field"

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/audit_reports/#{@model.get('id')}"
      data:
        audit_report:
          name: @$input.val()
    )
