class AuditReports.Views.AddMeasureModal extends Modal
  events:
    'click .js-add-measure-submit': 'onClickAddMeasureSubmit'
    'click .js-modal-close': 'onClickClose'
  
  afterLoad: ->
    @$form = @$('form')

  onClickAddMeasureSubmit: (event) ->
    event.preventDefault()
    $.ajax(
      url: @measureSelectionUrl(),
      data: @$form.serialize(),
      method: 'POST',
      success: (data) =>
        @model.get('measure_selections').push(data.measure_selection)
        triggerAuditReportSummary(data)
        @$el.trigger('closeModal')
    )

  measureSelectionUrl: ->
    id = @model.get('id')
    "/calc/audit_reports/#{id}/measure_selections"
