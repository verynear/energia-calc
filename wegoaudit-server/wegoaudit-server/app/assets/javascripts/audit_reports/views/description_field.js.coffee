class AuditReports.Views.DescriptionField extends AuditReports.Views.Field
  className: 'col-6'

  inputClass: "js-description-field"

  template: _.template """
    <div class="fli js-fli">
      <div class="fli__label">Description</div>
      <textarea class="fli__input js-fli-input"><%= value %></textarea>
    </div>
  """

  setHtml: ->
    @template(
      value: @model.get('description')
    )

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/audit_reports/#{@model.get('report_id')}/" +
           "measure_selections/#{@model.get('id')}"
      data:
        measure_selection:
          description: @$input.val()
      success: @_afterSyncFieldValue
    )

  _afterSyncFieldValue: (data) ->
    # noop
