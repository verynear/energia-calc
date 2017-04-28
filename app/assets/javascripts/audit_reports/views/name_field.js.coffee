class AuditReports.Views.NameField extends AuditReports.Views.Field
  className: 'col-auto'

  inputClass: "js-structure-name-field"

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/structures/#{@model.get('id')}"
      data:
        structure:
          name: @$input.val()
    )
