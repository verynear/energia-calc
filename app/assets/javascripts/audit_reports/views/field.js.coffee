class AuditReports.Views.Field extends Backbone.View
  tagName: 'div'
  className: 'col-6'

  inputClass: "js-structure-field"

  events:
    'click .js-reset-value': '_onClickResetLink'
    'click': '_onClickFliDiv'
    'change': '_onChangeInputValue'
    'focus .js-fli-input': '_onFocusInput'

  inputFieldTemplate: _.template """
    <div class="fli js-fli">
      <label class="fli__label"><%= name %></label>
      <input data-api-name='<%= apiName %>'
             type="text"
             class="fli__input js-fli-input"
             required
             <%= pattern %>
             value="<%= value %>">
    </div>
  """

  selectFieldTemplate: _.template """
    <div class="fli fli--has-select js-fli">
      <label class="fli__label"><%= name %></label>
      <select data-api-name='<%= apiName %>'
              class='js-fli-input fli__input'
              required>
        <option value="">Select an option</option>
        <%= options %>
      </select>
    </div>
  """

  resetIconHtml: """
    <a href="#" class="fli__reset fli__append js-reset-value">
      <i class="icon-reset"></i>
    </a>
  """

  render: ->
    html = @setHtml()
    @$el.html(html)

    @$fli = @$('.js-fli')
    @$input = @$('.js-fli-input')
    @$input.addClass(@inputClass)

    @_checkValidity()

    # For some reason this doesn't work when tracked in the events hash
    @$input.on('blur', @_onBlurInput)

    if @$input.val() != ''
      @$fli.addClass('is-completed')
    else if @model.get('default')
      @$fli.addClass('is-completed')
      @$fli.removeClass('error')
      @$input.attr('placeholder', @model.get_default_value)
    @setDisabled()

    if @model.get('from_audit')
      @$fli.append(@resetIconHtml)
    @$el

  setHtml: ->
    if @model.get('value_type') == 'picker'
      options = _(@model.get('options')).map (option) =>
        selected = if option == @model.get('value') then 'selected' else ''
        "<option #{selected} value='#{option}'>#{option}</option>"
      @selectFieldTemplate(
        name: @model.get('name')
        apiName: @model.get('api_name')
        value: @model.get('value')
        options: options.join(''))
    else
      @inputFieldTemplate(
        name: @title(),
        apiName: @model.get('api_name')
        value: @model.get('value')
        pattern: @_validationPattern())

  title: ->
    @model.get('name')

  _onClickResetLink: (event) ->
    event.preventDefault()
    @$input.val(@model.get('original_value'))
    @syncFieldValue()

  _onBlurInput: (event) =>
    @$input.removeClass('is-active')

    @_checkValidity()

    if @$input.val() == '' && !@model.get('default')
      @$fli.removeClass('is-completed')

  _onChangeInputValue: (event) ->
    @model.set(value: @$input.val())
    @syncFieldValue()

  _onClickFliDiv: (event) ->
    event.preventDefault()
    @$input.focus()

  _onFocusInput: (event) ->
    @$fli.addClass('is-completed')
    @$input.addClass('is-active')

    prependWidth = @$input.siblings('.js-fli-prepend').outerWidth()
    appendWidth = @$input.siblings('.js-fli-append, .js-reset-value')
      .outerWidth()

    @$input.css({'padding-left': prependWidth, 'padding-right': appendWidth})
    @$input.siblings('.js-reset-value').fadeIn()

  _checkValidity: ->
    if @model.get('default') && @$fli.val() == ''
      @$fli.removeClass('error')
    else if !@$input.get(0).checkValidity()
      @$fli.addClass('error')
    else
      @$fli.removeClass('error')

  setDisabled: ->
    if @$input.prop('disabled')
      @$fli.addClass('is-disabled')

  syncUrl: ->
    "/calc/structures/#{@model.get('structure').get('id')}" +
      "/field_values/#{@model.get('id')}"

  syncFieldValue: ->
    $.ajax(
      method: 'PUT'
      url: @syncUrl()
      data: { value: @$input.val() }
      success: @_afterSyncFieldValue
    )

  _afterSyncFieldValue: (data) ->
    triggerAuditReportSummary(data)

  _validationPattern: ->
    if @model.get('value_type') in ['decimal', 'integer']
      "pattern='\\d+(\\.?\\d+)?'"
