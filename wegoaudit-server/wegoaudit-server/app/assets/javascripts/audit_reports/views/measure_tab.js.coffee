class AuditReports.Views.MeasureTab extends Backbone.View
  tagName: 'li'
  className: 'js-measure-tab'

  template: _.template """
    <a href='#'>
      <i class='icon-grippy measures-tabs__grippy'></i>
      <%= name %>
    </a>
  """

  events:
    'click': 'onClick'
    'drop': 'onDrop'

  initialize: (options = {}) ->
    @listenTo(@model, 'change:active', @render)
    @listenTo(@model, 'change:enabled', @render)
    @listenTo(@collection, 'add', @render)

  render: ->
    @$el.html(@template(name: @model.get('name')))
    @$el.data('index', @$el.index())

    if @model.get('active')
      @$el.addClass('active')
    else
      @$el.removeClass('active')

    if @model.get('enabled')
      @$el.removeClass('excluded')
    else
      @$el.addClass('excluded')

    @$el

  measureSelectionUrl: () ->
    report_id = @model.get('report_id')
    id = @model.get('id')
    "/audit_reports/#{report_id}/measure_selections/#{id}"

  onClick: (event) ->
    event.preventDefault()
    @model.collection.setActive(@model)

  onDrop: (event) ->
    $.ajax(
      method: 'PUT'
      url: @measureSelectionUrl()
      data:
        measure_selection:
          calculate_order_position: @$el.index()
      success: (data) ->
        triggerAuditReportSummary(data)
    )
