class AuditReports.Views.MeasureField extends AuditReports.Views.Field
  className: 'col-3'
  inputClass: "js-measure-selection-field"

  syncUrl: ->
    "/calc/measure_selections/#{@model.get('measure_summary').get('id')}/" +
      "field_values/#{@model.get('id')}"
