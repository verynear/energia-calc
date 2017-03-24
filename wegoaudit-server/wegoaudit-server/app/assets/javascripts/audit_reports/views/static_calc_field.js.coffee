class AuditReports.Views.StaticCalcField extends Backbone.View
  className: "col-3"

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
    { @name, @value } = options

  render: ->
    @$el.html(@template(name: @name, value: @value))
    @$el
