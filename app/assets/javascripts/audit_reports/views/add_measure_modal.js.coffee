class AuditReports.Views.AddMeasureModal extends Modal
  afterLoad: ->
    @$form = @$('form')

  submitForm: (event) ->
    event.preventDefault()

    $.ajax(
      url: @$form.attr('action'),
      data: @$form.serialize(),
      method: 'POST',
      success: (data) =>
        @model.get('measure_selections').push(data.measure_selection)
        triggerAuditReportSummary(data)
        @$el.trigger('closeModal')
    )
