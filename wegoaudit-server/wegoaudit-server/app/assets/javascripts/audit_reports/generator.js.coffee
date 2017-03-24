class AuditReports.Generator
  constructor: (params) ->
    auditReport = new AuditReports.Models.AuditReport(params.audit_report)

    if params.page == 'edit_audit_report'
      page = new AuditReports.Views.EditAuditReportPage(
        el: $('body')
        model: auditReport
        fields: params.calc_fields
      )
    else
      page = new AuditReports.Views.ManageMeasuresPage(
        el: $('body')
        model: auditReport
        measureModalUrl: params.measureModalUrl
      )

    page.render()
