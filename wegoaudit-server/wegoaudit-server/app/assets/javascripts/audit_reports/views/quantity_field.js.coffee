class AuditReports.Views.QuantityField extends AuditReports.Views.Field
  className: 'col-2 end-row'

  inputClass: "js-structure-quantity-field"

  originalTemplate: _.template """
    <div class="fli js-fli">
      <label class="fli__label"><%= name %></label>
      <input data-api-name='<%= apiName %>'
             type="text"
             class="fli__input js-fli-input"
             required
             <%= pattern %>
             value="<%= value %>">
      <span class="fli__append js-fli-append">/<%= nStructures %></span>
    </div>
  """

  initialize: (options = {}) ->
    @original = options.original ? true

  nStructures: ->
    @model.get('original_value')

  setDisabled: ->
    if @nStructures() == 1
      @$fli.addClass('is-disabled')

  setHtml: ->
    if @original
      @originalTemplate(
        name: @model.get('name')
        apiName: @model.get('api_name')
        value: @model.get('value')
        nStructures: @nStructures()
        pattern: @_validationPattern()
      )
    else
      super

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: "/calc/calc_structures/#{@model.get('id')}"
      data:
        structure:
          quantity: @$input.val()
      success: @_afterSyncFieldValue
    )
