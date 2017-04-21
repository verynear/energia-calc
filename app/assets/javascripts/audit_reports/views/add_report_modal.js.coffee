class AuditReports.Views.AddReportModal extends Modal
  afterLoad: ->
    @$form = @$('form')

  submitForm: (event) ->
    unless @$('.js-select-audit-radio-button').is(':checked')
      $('.js-select-audit-error-msg').removeClass('hide')
      event.preventDefault()
