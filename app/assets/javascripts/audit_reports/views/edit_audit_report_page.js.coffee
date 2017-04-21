class AuditReports.Views.EditAuditReportPage extends Backbone.View
  initialize: (options = {}) ->
    { @measureModalUrl, @fields } = options

  render: ->
    @$('.content > .container')
      .html("<div class='js-edit-audit-report'></div>")
    $editAuditReport = $('.js-edit-audit-report')
    @fields.forEach (section) =>
      row = new AuditReports.Views.AuditReportFieldsRow(
        model: @model
        section: section)
      $editAuditReport.append(row.render())

    totalsBar = new AuditReports.Views.TotalsBar(
      model: @model.get('audit_report_summary')
    )
    @$('.content').after(totalsBar.render())
    totalsBar.postRender()
    @$el
