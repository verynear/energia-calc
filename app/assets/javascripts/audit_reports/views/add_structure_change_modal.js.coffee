class AuditReports.Views.AddStructureChangeModal extends Modal
  afterLoad: ->
    @$form = @$('form')

  submitForm: (event) ->
    unless @$('.js-select-audit-radio-button').is(':checked')
      $('.js-select-audit-error-msg').removeClass('hide')
      event.preventDefault()

      $.ajax(
        url: "/calc/audit_reports/#{@model.get('measure_selection_id')}/" +
           "structure_changes",
        data: @$form.serialize(),
        method: 'POST',
        success: (data) =>
          @model.set(data.measure_selection)
          @collection.add(data.structure_changes)
          @$el.trigger('closeModal')
          triggerAuditReportSummary(data)
      )
