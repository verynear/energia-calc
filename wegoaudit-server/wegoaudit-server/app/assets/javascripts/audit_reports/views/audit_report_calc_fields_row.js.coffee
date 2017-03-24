class AuditReports.Views.AuditReportCalcFieldsRow extends Backbone.View
  tagName: 'div'

  initialize: (options = {}) ->
    { @section } = options

  render: ->
    @$el.append("<h3>#{@section.title}</h3>")
    @section.rows.forEach (row) =>
      $row = $("<div class='row'></div>")
      row.forEach (apiName) =>
        if apiName == 'report_name'
          calcfieldValue = @model.get('audit_report_name_calc_field_value')
          calcField = new AuditReports.Views.AuditReportNameCalcField(model: calcfieldValue)
        else
          calcfieldValue = @model.get('calc_field_values').find(
            (item) ->
              item.get('api_name') == apiName
          )
          field = new AuditReports.Views.AuditReportCalcField(model: calcfieldValue)
        $row.append(field.render())
      @$el.append($row)
    @$el
