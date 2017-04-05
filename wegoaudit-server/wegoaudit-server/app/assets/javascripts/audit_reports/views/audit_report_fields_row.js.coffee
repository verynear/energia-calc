class AuditReports.Views.AuditReportFieldsRow extends Backbone.View
  tagName: 'div'

  initialize: (options = {}) ->
    { @section } = options

  render: ->
    @$el.append("<h3>#{@section.title}</h3>")
    @section.rows.forEach (row) =>
      $row = $("<div class='row'></div>")
      row.forEach (apiName) =>
        if apiName == 'report_name'
          fieldValue = @model.get('audit_report_name_field_value')
          Field = new AuditReports.Views.AuditReportNameField(model: calcfieldValue)
        else
          fieldValue = @model.get('calc_field_values').find(
            (item) ->
              item.get('api_name') == apiName
          )
          field = new AuditReports.Views.AuditReportField(model: calcfieldValue)
        $row.append(field.render())
      @$el.append($row)
    @$el
