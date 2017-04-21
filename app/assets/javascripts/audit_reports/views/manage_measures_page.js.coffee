class AuditReports.Views.ManageMeasuresPage extends Backbone.View
  events:
    'click .js-add-measure-link': 'onClickAddMeasureLink'

  initialize: (options = {}) ->
    { @measureModalUrl } = options

  render: ->
    @$('.content > .container')
      .html("<div class='js-measures-manager'></div>")
    $manageMeasures = @$('.js-measures-manager')
    manager = new AuditReports.Views.MeasuresManager(
      model: @model
      el: $manageMeasures)
    manager.render()

    totalsBar = new AuditReports.Views.TotalsBar(
      model: @model.get('audit_report_summary')
    )
    @$('.content').after(totalsBar.render())
    totalsBar.postRender()
    @$el

  onClickAddMeasureLink: (event) ->
    event.preventDefault()
    modal = new AuditReports.Views.AddMeasureModal(
      model: @model
      url: @measureModalUrl)
    modal.render()
