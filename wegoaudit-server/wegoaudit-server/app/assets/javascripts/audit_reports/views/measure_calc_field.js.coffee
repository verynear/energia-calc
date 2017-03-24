class AuditReports.Views.MeasureCalcField extends AuditReports.Views.CalcField
  className: 'col-3'
  inputClass: "js-measure-selection-calc-field"

  syncUrl: ->
    "/calc/measure_selections/#{@model.get('measure_summary').get('id')}/" +
      "calc_field_values/#{@model.get('id')}"
