class AuditReports.Views.NameCalcField extends AuditReports.Views.CalcField
  className: 'col-auto'

  inputClass: "js-structure-name-calc-field"

  syncCalcFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/calc_structures/#{@model.get('id')}"
      data:
        structure:
          name: @$input.val()
    )
