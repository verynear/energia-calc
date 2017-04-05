class AuditReports.Views.RecommendationField extends AuditReports.Views.Field
  className: 'col-6'

  inputClass: "js-recommendation-field"

  template: _.template """
    <div class="fli js-fli">
      <div class="fli__label">Recommendation</div>
      <textarea class="fli__input js-fli-input"><%= value %></textarea>
    </div>
  """

  setHtml: ->
    @template(
      value: @model.get('recommendation')
    )

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/audit_reports/#{@model.get('report_id')}/" +
           "measure_selections/#{@model.get('id')}"
      data:
        measure_selection:
          recommendation: @$input.val()
      success: @_afterSyncFieldValue
    )

  _afterSyncFieldValue: (data) ->
    # noop
