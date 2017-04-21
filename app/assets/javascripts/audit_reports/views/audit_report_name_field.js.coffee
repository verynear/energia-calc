class AuditReports.Views.AuditReportNameField extends AuditReports.Views.Field
  className: 'col-3'

  inputClass: "js-audit-report-name-field"

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/audit_reports/#{@model.get('id')}"
      data:
        audit_report:
          name: @$input.val()
    )
