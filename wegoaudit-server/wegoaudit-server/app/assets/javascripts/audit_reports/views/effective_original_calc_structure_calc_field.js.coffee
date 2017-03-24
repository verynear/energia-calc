class AuditReports.Views.EffectiveCalcStructureCalcField extends Backbone.View
  className: 'js-effective-calc-structure-calc-field'

  template: _.template """
    <div class="fli is-completed">
      <label class="fli__label"><%= name %></label>
      <input type="text"
             class="fli__input"
             value="<%= value %>"
             disabled>
    </div>
  """

  initialize: (options) ->
    @$el.attr('data-api_name', @model.get('api_name'))
    @listenTo(@model, 'change:effective_value', @render)

    { @name, @value } = options

  render: ->
    html = @template(
      name: @_name(),
      value: @model.get('effective_value')
    )
    @$el.html(html)
    @$el

  _name: ->
    "Effective #{@model.get('name')}"

