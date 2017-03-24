class AuditReports.Views.EditAuditReportPage extends Backbone.View
  initialize: (options = {}) ->
    { @measureModalUrl, @calcFields } = options

  render: ->
    @$('.content > .container')
      .html("<div class='js-edit-audit-report'></div>")
    $editAuditReport = $('.js-edit-audit-report')
    @calc_fields.forEach (section) =>
      row = new AuditReports.Views.AuditReportCalcFieldsRow(
        model: @model
        section: section)
      $editAuditReport.append(row.render())

    totalsBar = new AuditReports.Views.TotalsBar(
      model: @model.get('audit_report_summary')
    )
    @$('.content').after(totalsBar.render())
    totalsBar.postRender()
    @$el
